create table if not exists public.reservation (
  id uuid primary key default gen_random_uuid(),
  guest_name text not null check (char_length(guest_name) between 1 and 80),
  phone text not null check (char_length(phone) between 6 and 30),
  party_size text not null check (party_size in ('2 位', '3 位', '4 位', '5-6 位')),
  reservation_date date not null default ((now() at time zone 'Asia/Seoul')::date),
  reservation_time time not null,
  special_requests text not null default '' check (char_length(special_requests) <= 200),
  status text not null default 'pending' check (status in ('pending', 'confirmed', 'cancelled')),
  created_at timestamptz not null default now()
);

alter table public.reservation enable row level security;

revoke all on table public.reservation from anon, authenticated;
grant insert on table public.reservation to anon;

drop policy if exists "Public can create reservations" on public.reservation;
create policy "Public can create reservations"
on public.reservation
for insert
to anon
with check (status = 'pending');

comment on table public.reservation is 'Restaurant reservation requests submitted from the public website.';
