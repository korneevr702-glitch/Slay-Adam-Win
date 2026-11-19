create table if not exists public.slay_votes (
  id bigint generated always as identity primary key,
  category text not null check (category in ('king', 'queen')),
  nominee_id text not null,
  voter_id uuid not null,
  created_at timestamptz not null default now(),
  constraint slay_votes_nominee_category_check check (
    (category = 'king' and nominee_id in ('timaevvv','evelone','bratishkin','leva2k','sasavot','strogo','deepins','anar'))
    or
    (category = 'queen' and nominee_id in ('gensyxa','morphe','byowl','gaechka'))
  ),
  constraint slay_votes_one_per_category unique (category, voter_id)
);

alter table public.slay_votes enable row level security;

create policy "Public can read slay votes"
  on public.slay_votes for select to anon, authenticated using (true);

create policy "Public can submit slay votes"
  on public.slay_votes for insert to anon, authenticated with check (true);

grant select, insert on public.slay_votes to anon, authenticated;
grant usage, select on sequence public.slay_votes_id_seq to anon, authenticated;

do $$
begin
  alter publication supabase_realtime add table public.slay_votes;
exception when duplicate_object then null;
end $$;
