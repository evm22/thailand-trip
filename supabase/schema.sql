-- Thailand trip: run once in Supabase → SQL Editor.
-- Every item (expense, flight, hotel, check, …) is its own row, so concurrent
-- edits from different phones never overwrite each other. Deletions are
-- tombstones (deleted = true) so an offline device can't bring an item back.

create table if not exists public.items (
  coll       text        not null,           -- th_exps, th_hotels_v2, …
  id         text        not null,           -- item id (or key, for th_rates / th_dayplans / th_poi_state)
  data       jsonb,
  deleted    boolean     not null default false,
  updated_at timestamptz not null default clock_timestamp(),
  updated_by uuid                 default auth.uid(),
  primary key (coll, id)
);
create index if not exists items_updated_at_idx on public.items (updated_at);

create or replace function public.items_touch() returns trigger
language plpgsql as $$
begin
  new.updated_at := clock_timestamp();
  new.updated_by := auth.uid();
  return new;
end $$;
drop trigger if exists items_touch on public.items;
create trigger items_touch before insert or update on public.items
  for each row execute function public.items_touch();

-- Only signed-in travelers can read or write. No delete policy: deletes are tombstones.
alter table public.items enable row level security;
drop policy if exists "travelers read"   on public.items;
drop policy if exists "travelers insert" on public.items;
drop policy if exists "travelers update" on public.items;
create policy "travelers read"   on public.items for select to authenticated using (true);
create policy "travelers insert" on public.items for insert to authenticated with check (true);
create policy "travelers update" on public.items for update to authenticated using (true) with check (true);

-- Private bucket for attachments; files are downloaded only when opened.
insert into storage.buckets (id, name, public)
values ('trip-files', 'trip-files', false)
on conflict (id) do nothing;

drop policy if exists "travelers read files"   on storage.objects;
drop policy if exists "travelers add files"    on storage.objects;
drop policy if exists "travelers update files" on storage.objects;
drop policy if exists "travelers delete files" on storage.objects;
create policy "travelers read files"   on storage.objects for select to authenticated using (bucket_id = 'trip-files');
create policy "travelers add files"    on storage.objects for insert to authenticated with check (bucket_id = 'trip-files');
create policy "travelers update files" on storage.objects for update to authenticated using (bucket_id = 'trip-files');
create policy "travelers delete files" on storage.objects for delete to authenticated using (bucket_id = 'trip-files');
