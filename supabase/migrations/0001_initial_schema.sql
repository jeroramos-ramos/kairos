-- ============================================================
-- Kairos Demo — Initial Schema
-- ============================================================


-- ------------------------------------------------------------
-- 1. Extensions
-- ------------------------------------------------------------

create extension if not exists vector;


-- ------------------------------------------------------------
-- 2. orgs
-- ------------------------------------------------------------

create table orgs (
  id         uuid        primary key default gen_random_uuid(),
  name       text        not null,
  created_at timestamptz default now()
);


-- ------------------------------------------------------------
-- 3. org_members
-- ------------------------------------------------------------

create table org_members (
  org_id     uuid  references orgs(id)       on delete cascade,
  user_id    uuid  references auth.users(id)  on delete cascade,
  role       text  check (role in ('admin', 'member')) default 'admin',
  created_at timestamptz default now(),
  primary key (org_id, user_id)
);


-- ------------------------------------------------------------
-- 4. brands
-- ------------------------------------------------------------

create table brands (
  id                    uuid         primary key default gen_random_uuid(),
  org_id                uuid         references orgs(id) on delete cascade not null,
  name                  text         not null,
  website               text,
  category              text,
  ticket_avg_cents      int,
  description           text,
  description_embedding vector(1536),
  target_audience       jsonb,
  brand_voice           text,
  created_at            timestamptz  default now()
);


-- ------------------------------------------------------------
-- 5. campaigns
-- ------------------------------------------------------------

create table campaigns (
  id           uuid         primary key default gen_random_uuid(),
  brand_id     uuid         references brands(id) on delete cascade not null,
  name         text         not null,
  objective    text         check (objective in (
                              'awareness', 'sales', 'traffic',
                              'positioning', 'launch', 'engagement'
                            )),
  budget_cents int,
  countries    text[],
  platforms    text[],
  status       text         default 'draft',
  brief        jsonb,
  created_at   timestamptz  default now()
);


-- ------------------------------------------------------------
-- 6. creators  (public catalogue — no RLS in demo)
-- ------------------------------------------------------------

create table creators (
  id                uuid         primary key default gen_random_uuid(),
  handle            text         not null,
  platform          text         check (platform in ('tiktok', 'instagram', 'youtube')),
  follower_count    int,
  engagement_rate   numeric,
  fake_follower_pct numeric,
  niche             text[],
  country           text,
  audience_demo     jsonb,
  content_embedding vector(1536),
  avatar_initials   text,
  created_at        timestamptz  default now(),
  unique (handle, platform)
);


-- ------------------------------------------------------------
-- 7. matches
-- ------------------------------------------------------------

create table matches (
  id                      uuid         primary key default gen_random_uuid(),
  campaign_id             uuid         references campaigns(id) on delete cascade,
  creator_id              uuid         references creators(id),
  score                   numeric,
  score_breakdown         jsonb,
  recommended_brief       jsonb,
  status                  text         default 'suggested',
  fee_estimate_cents      int,
  campaign_recommendation text,
  created_at              timestamptz  default now()
);


-- ------------------------------------------------------------
-- 8. Enable RLS  (creators excluded — public catalogue)
-- ------------------------------------------------------------

alter table orgs        enable row level security;
alter table org_members enable row level security;
alter table brands      enable row level security;
alter table campaigns   enable row level security;
alter table matches     enable row level security;


-- ------------------------------------------------------------
-- 9. Policies
-- ------------------------------------------------------------

-- orgs: a user can see any org they belong to
create policy "orgs_select_own"
  on orgs
  for select
  using (
    exists (
      select 1 from org_members
      where org_members.org_id  = orgs.id
        and org_members.user_id = auth.uid()
    )
  );

-- org_members: each user sees only their own membership rows
create policy "org_members_select_own"
  on org_members
  for select
  using (user_id = auth.uid());

-- brands: full CRUD for any member of the brand's org
create policy "brands_select"
  on brands
  for select
  using (
    exists (
      select 1 from org_members
      where org_members.org_id  = brands.org_id
        and org_members.user_id = auth.uid()
    )
  );

create policy "brands_insert"
  on brands
  for insert
  with check (
    exists (
      select 1 from org_members
      where org_members.org_id  = brands.org_id
        and org_members.user_id = auth.uid()
    )
  );

create policy "brands_update"
  on brands
  for update
  using (
    exists (
      select 1 from org_members
      where org_members.org_id  = brands.org_id
        and org_members.user_id = auth.uid()
    )
  );

create policy "brands_delete"
  on brands
  for delete
  using (
    exists (
      select 1 from org_members
      where org_members.org_id  = brands.org_id
        and org_members.user_id = auth.uid()
    )
  );

-- campaigns: full CRUD if user is member of the campaign's brand's org
create policy "campaigns_select"
  on campaigns
  for select
  using (
    exists (
      select 1 from brands
      join org_members on org_members.org_id = brands.org_id
      where brands.id            = campaigns.brand_id
        and org_members.user_id  = auth.uid()
    )
  );

create policy "campaigns_insert"
  on campaigns
  for insert
  with check (
    exists (
      select 1 from brands
      join org_members on org_members.org_id = brands.org_id
      where brands.id            = campaigns.brand_id
        and org_members.user_id  = auth.uid()
    )
  );

create policy "campaigns_update"
  on campaigns
  for update
  using (
    exists (
      select 1 from brands
      join org_members on org_members.org_id = brands.org_id
      where brands.id            = campaigns.brand_id
        and org_members.user_id  = auth.uid()
    )
  );

create policy "campaigns_delete"
  on campaigns
  for delete
  using (
    exists (
      select 1 from brands
      join org_members on org_members.org_id = brands.org_id
      where brands.id            = campaigns.brand_id
        and org_members.user_id  = auth.uid()
    )
  );

-- matches: full CRUD if user is member of the org that owns the campaign's brand
create policy "matches_select"
  on matches
  for select
  using (
    exists (
      select 1 from campaigns
      join brands      on brands.id            = campaigns.brand_id
      join org_members on org_members.org_id   = brands.org_id
      where campaigns.id          = matches.campaign_id
        and org_members.user_id   = auth.uid()
    )
  );

create policy "matches_insert"
  on matches
  for insert
  with check (
    exists (
      select 1 from campaigns
      join brands      on brands.id            = campaigns.brand_id
      join org_members on org_members.org_id   = brands.org_id
      where campaigns.id          = matches.campaign_id
        and org_members.user_id   = auth.uid()
    )
  );

create policy "matches_update"
  on matches
  for update
  using (
    exists (
      select 1 from campaigns
      join brands      on brands.id            = campaigns.brand_id
      join org_members on org_members.org_id   = brands.org_id
      where campaigns.id          = matches.campaign_id
        and org_members.user_id   = auth.uid()
    )
  );

create policy "matches_delete"
  on matches
  for delete
  using (
    exists (
      select 1 from campaigns
      join brands      on brands.id            = campaigns.brand_id
      join org_members on org_members.org_id   = brands.org_id
      where campaigns.id          = matches.campaign_id
        and org_members.user_id   = auth.uid()
    )
  );


-- ------------------------------------------------------------
-- 10. Auto-provision org on user signup
-- ------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  new_org_id uuid;
  org_name   text;
begin
  -- derive org name from email prefix (e.g. "jeronimo" from "jeronimo@mail.com")
  org_name := split_part(new.email, '@', 1);

  insert into public.orgs (name)
  values (org_name)
  returning id into new_org_id;

  insert into public.org_members (org_id, user_id, role)
  values (new_org_id, new.id, 'admin');

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- ------------------------------------------------------------
-- 11. Indices
-- ------------------------------------------------------------

-- vector similarity search on creators (cosine distance, IVFFlat)
create index on creators using ivfflat (content_embedding vector_cosine_ops) with (lists = 100);

-- match lookup ordered by score (most relevant first)
create index on matches (campaign_id, score desc);

-- membership lookups by user
create index on org_members (user_id);

-- brand lookup by org
create index on brands (org_id);

-- campaign lookup by brand
create index on campaigns (brand_id);
