create or replace function public.lookup_reservations_by_phone(lookup_phone text)
returns table (
  reservation_date date,
  reservation_time time,
  party_size text,
  special_requests text,
  status text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  normalized_phone text;
begin
  normalized_phone := regexp_replace(coalesce(lookup_phone, ''), '[^0-9]', '', 'g');

  if char_length(normalized_phone) < 6 or char_length(normalized_phone) > 20 then
    return;
  end if;

  return query
  select
    reservation.reservation_date,
    reservation.reservation_time,
    reservation.party_size,
    reservation.special_requests,
    reservation.status
  from public.reservation
  where regexp_replace(reservation.phone, '[^0-9]', '', 'g') = normalized_phone
  order by
    reservation.reservation_date desc,
    reservation.reservation_time desc,
    reservation.created_at desc
  limit 20;
end;
$$;

revoke execute on function public.lookup_reservations_by_phone(text) from public;
grant execute on function public.lookup_reservations_by_phone(text) to anon, authenticated;

comment on function public.lookup_reservations_by_phone(text)
is 'Returns a limited, non-identifying reservation summary for an exact normalized phone number.';
