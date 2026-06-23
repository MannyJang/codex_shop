create schema if not exists private;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
revoke all on table public.admin_users from anon, authenticated;

create or replace function private.is_reservation_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

revoke all on function private.is_reservation_admin() from public;
grant usage on schema private to authenticated;
grant execute on function private.is_reservation_admin() to authenticated;

grant select on table public.reservation to authenticated;
grant update (status) on table public.reservation to authenticated;
grant insert on table public.reservation to authenticated;

drop policy if exists "Authenticated can create reservations" on public.reservation;
create policy "Authenticated can create reservations"
on public.reservation
for insert
to authenticated
with check (status = 'pending');

drop policy if exists "Admins can read reservations" on public.reservation;
create policy "Admins can read reservations"
on public.reservation
for select
to authenticated
using ((select private.is_reservation_admin()));

drop policy if exists "Admins can update reservation status" on public.reservation;
create policy "Admins can update reservation status"
on public.reservation
for update
to authenticated
using ((select private.is_reservation_admin()))
with check (
  (select private.is_reservation_admin())
  and status in ('pending', 'confirmed', 'cancelled')
);

comment on table public.admin_users is 'Supabase Auth users allowed to manage reservations.';
