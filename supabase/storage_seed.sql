-- ============================================================
-- JUM Storage Seed Data File
-- Inserts metadata into storage.objects for referenced assets
-- ============================================================

TRUNCATE storage.objects CASCADE;

-- ── 1. AVATARS BUCKET OBJECTS ────────────────────────────────
INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '48d36964-7143-5465-9fff-d0e254ce7138',
  'avatars',
  '6b0dd36d-93f9-504c-abc6-4bf98e01c770/avatar.jpg',
  '6b0dd36d-93f9-504c-abc6-4bf98e01c770',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '59d3b296-e623-5ea5-b9e0-0f27e8b8bf75',
  'avatars',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b/avatar.jpg',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'b3fe708b-bfc4-5b9e-89c0-689fb5d03d9a',
  'avatars',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135/avatar.jpg',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '59c17cfd-da59-5203-bc8e-d5fd9a372bc1',
  'avatars',
  '71f38ffd-beb1-5ecb-90cf-014856476afe/avatar.jpg',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '86e65b56-0aac-5ea9-b81e-510f8e370fd8',
  'avatars',
  '9aea834a-81d0-586a-986e-987fa8a71d2a/avatar.jpg',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '57bada7b-1702-5d73-bf9e-5232cddd2753',
  'avatars',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e/avatar.jpg',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '03c9c4f5-eaaa-58b0-aee0-7c800c9b53ba',
  'avatars',
  '5006102e-5fe9-5473-82f1-f67c327172d0/avatar.jpg',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'a49a0032-fe13-5fae-8f31-136c14f59338',
  'avatars',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423/avatar.jpg',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '4c0a27e4-5df6-5a11-a64a-cf87b3b3be78',
  'avatars',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2/avatar.jpg',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '6e33fd26-7343-5858-8c04-beb37bc26883',
  'avatars',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac/avatar.jpg',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '9afba1d0-5f40-5635-b93e-8563a596bb64',
  'avatars',
  '2e67cc75-477f-5e66-a641-fa76985d10e4/avatar.jpg',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'dad45f92-8902-5380-b0f8-a67a1ca822b4',
  'avatars',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d/avatar.jpg',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '6dbdf1c0-3125-5cdc-8f47-2d645c5530be',
  'avatars',
  '8a11f317-311d-5241-b8a0-455f712265b5/avatar.jpg',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'b54b66c4-91a0-520a-b094-ad6417da7f01',
  'avatars',
  '51e088ae-312d-5511-8546-14f07c1dd8b2/avatar.jpg',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'b2c6668d-26f6-5b61-9d8a-b6d883f2baea',
  'avatars',
  '030eb783-fe4c-5b65-aee2-a921a1977359/avatar.jpg',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '4497663a-b89a-5b88-808f-f8855d7a1794',
  'avatars',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7/avatar.jpg',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '1577d22d-b437-5efc-bddd-40e95178173d',
  'avatars',
  '1164ec13-a4de-5cc0-8eac-eb8833b16640/avatar.jpg',
  '1164ec13-a4de-5cc0-8eac-eb8833b16640',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '08a6483d-34e1-5210-b937-67bd76050cc3',
  'avatars',
  '1c27aaa9-2781-5750-9b68-25fee3a17b99/avatar.jpg',
  '1c27aaa9-2781-5750-9b68-25fee3a17b99',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'af6410b8-5a11-5225-988e-8e5bc0555dde',
  'avatars',
  '7126763d-b662-5599-8069-51cbfe88a56a/avatar.jpg',
  '7126763d-b662-5599-8069-51cbfe88a56a',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '398c414a-4c68-54f6-b8a9-8d10acc1dcc4',
  'avatars',
  '7a9058c3-61ed-5188-b233-69fca99e66c0/avatar.jpg',
  '7a9058c3-61ed-5188-b233-69fca99e66c0',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '1b00d94b-508a-5e7a-ac5a-0655dce17934',
  'avatars',
  'e453775a-166a-54df-a5b2-0081c12608dd/avatar.jpg',
  'e453775a-166a-54df-a5b2-0081c12608dd',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '75bab93d-687c-5534-beac-11ac6710acac',
  'avatars',
  '051c1a02-6308-5a77-a3f1-f6cd8229242e/avatar.jpg',
  '051c1a02-6308-5a77-a3f1-f6cd8229242e',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '8e0276f0-7b33-5a27-af7f-06f017aa8592',
  'avatars',
  '14078da6-ea92-59c8-aa32-fa74fec6e2c4/avatar.jpg',
  '14078da6-ea92-59c8-aa32-fa74fec6e2c4',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '62a9f257-5a8e-50c7-80f7-7cf1962752f4',
  'avatars',
  '13dcf743-d13f-5642-816c-e2421e3b775b/avatar.jpg',
  '13dcf743-d13f-5642-816c-e2421e3b775b',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '5c9fb6b6-c972-5ec7-b02b-f9a4da9c2529',
  'avatars',
  '5cceeb1d-7a95-5f43-8b5b-069ed1de1651/avatar.jpg',
  '5cceeb1d-7a95-5f43-8b5b-069ed1de1651',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '187da48e-1443-5994-a04a-00858f27e169',
  'avatars',
  '49326b61-166d-5ae6-b288-dfd08f776172/avatar.jpg',
  '49326b61-166d-5ae6-b288-dfd08f776172',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'd8c163aa-2d17-50f8-986c-210210ee021e',
  'avatars',
  '241613d3-48a5-5736-a503-fbbe390e8d02/avatar.jpg',
  '241613d3-48a5-5736-a503-fbbe390e8d02',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '5574b6ce-f147-5dfb-aacc-a37834087efd',
  'avatars',
  '8e08990d-1c10-52d4-95d5-a7a24656ac16/avatar.jpg',
  '8e08990d-1c10-52d4-95d5-a7a24656ac16',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'e887e8df-32c4-5c26-9cff-a2f77e5d8f36',
  'avatars',
  '8a279fe1-0ccc-5ad6-a3b4-01f13882be16/avatar.jpg',
  '8a279fe1-0ccc-5ad6-a3b4-01f13882be16',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '262b744d-a684-5d86-84f4-e67c5f22f484',
  'avatars',
  '17037c2d-a6ba-5ff3-a083-64d2b96b6000/avatar.jpg',
  '17037c2d-a6ba-5ff3-a083-64d2b96b6000',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '681f6b9b-b9c1-5ff3-93f0-8f321081b604',
  'avatars',
  'a23a905b-10d3-5c22-8f08-ba193b5fed24/avatar.jpg',
  'a23a905b-10d3-5c22-8f08-ba193b5fed24',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '20ef79dd-a537-5f86-aa96-61d6e43c3aa0',
  'avatars',
  '6b2dee77-c383-5011-aa9b-f2934b57ad3c/avatar.jpg',
  '6b2dee77-c383-5011-aa9b-f2934b57ad3c',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '4fdc13e9-4ff5-5721-9959-352f30f08167',
  'avatars',
  '0b0fc815-5048-5f88-a8e8-80ee60459e1b/avatar.jpg',
  '0b0fc815-5048-5f88-a8e8-80ee60459e1b',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '821caa9d-8d5d-5997-be82-25827fa1e390',
  'avatars',
  'd3e86c7c-5012-5fb9-99d6-40c4a04961d3/avatar.jpg',
  'd3e86c7c-5012-5fb9-99d6-40c4a04961d3',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '05771d30-7541-500a-a921-95bc232785e4',
  'avatars',
  'eca334aa-bf34-503b-ba8b-aaed8566256d/avatar.jpg',
  'eca334aa-bf34-503b-ba8b-aaed8566256d',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '7e092750-a134-54a6-a719-c0ac4a87bc9e',
  'avatars',
  'f7781772-4b52-5e49-8948-95f14685bb7d/avatar.jpg',
  'f7781772-4b52-5e49-8948-95f14685bb7d',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '33ccd223-a9a1-5621-afc5-d7a3de4e4697',
  'avatars',
  '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d/avatar.jpg',
  '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'ddeb68bf-5c1d-5b0b-abdc-3eb278d7e830',
  'avatars',
  '25a41fdc-b039-501f-af00-e6cb77497994/avatar.jpg',
  '25a41fdc-b039-501f-af00-e6cb77497994',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '6c81b6a4-aa16-5405-8bf3-7f7f22810609',
  'avatars',
  '0c01fe67-dc09-582a-9ec2-d9f5119d14fa/avatar.jpg',
  '0c01fe67-dc09-582a-9ec2-d9f5119d14fa',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '0e1c00d7-37a9-5d04-aa64-79b3c1e58816',
  'avatars',
  '2b34af49-23ce-53a0-ba9e-0ddc7662b96e/avatar.jpg',
  '2b34af49-23ce-53a0-ba9e-0ddc7662b96e',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '268be927-3790-51fb-8768-ac087e4eaa0d',
  'avatars',
  '99dd01fe-5504-5101-ab8c-311cef05ec2f/avatar.jpg',
  '99dd01fe-5504-5101-ab8c-311cef05ec2f',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '92e6fce9-4df7-5d16-9df5-c87eb5675137',
  'avatars',
  '1584522d-e8df-5ca4-b3b1-8d8d6d592aab/avatar.jpg',
  '1584522d-e8df-5ca4-b3b1-8d8d6d592aab',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '37434bbc-23a0-5bea-952a-2018d775a314',
  'avatars',
  'ce604ae9-9457-559c-b0eb-f2066025c432/avatar.jpg',
  'ce604ae9-9457-559c-b0eb-f2066025c432',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '49301573-e7c4-5668-bebf-3c09aa691f08',
  'avatars',
  '84eb7717-eca7-5f31-8de8-6428d9fb3a5b/avatar.jpg',
  '84eb7717-eca7-5f31-8de8-6428d9fb3a5b',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '10002ca9-bbf2-529e-8d89-eeddf38640ea',
  'avatars',
  '2a217c04-42ca-58b2-90e9-1be20d2a1932/avatar.jpg',
  '2a217c04-42ca-58b2-90e9-1be20d2a1932',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'a0c7a876-6690-5d22-ab93-2192c1be2c69',
  'avatars',
  'ef7ea51c-bcc3-5a18-aa91-f12fbdc904d9/avatar.jpg',
  'ef7ea51c-bcc3-5a18-aa91-f12fbdc904d9',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'af83fb22-44a3-50a8-9344-0614f0e0afea',
  'avatars',
  '12dd726a-5da0-598a-97a1-e68380a42e5b/avatar.jpg',
  '12dd726a-5da0-598a-97a1-e68380a42e5b',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'b8df944c-9e04-50f9-b80e-4a26184375b0',
  'avatars',
  'dc484d29-e587-5d05-a5d2-33676131d98d/avatar.jpg',
  'dc484d29-e587-5d05-a5d2-33676131d98d',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '5d312f07-8912-5504-bf65-ee56dbed0725',
  'avatars',
  '7faa6c92-a906-511a-aec9-2d32c5754bcd/avatar.jpg',
  '7faa6c92-a906-511a-aec9-2d32c5754bcd',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '01c30daa-2284-5125-9638-0fe477400959',
  'avatars',
  '55ef8a93-c32f-5f5e-a5c7-0923a351e57b/avatar.jpg',
  '55ef8a93-c32f-5f5e-a5c7-0923a351e57b',
  NOW(), NOW(), NOW(),
  '{"size": 24500, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

-- ── 2. MEDIA BUCKET OBJECTS ──────────────────────────────────
INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'b53a1b9c-b513-50f0-91f6-363dc754a29a',
  'sermons',
  'series/bb0a699e-3942-5514-adaa-2455a3ffe1ef/banner.jpg',
  NULL,
  NOW(), NOW(), NOW(),
  '{"size": 105400, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'db7ebde9-7aa3-5e75-a6a7-20d14e7f2308',
  'sermons',
  'series/a1e50289-de11-512a-b753-fef428856379/banner.jpg',
  NULL,
  NOW(), NOW(), NOW(),
  '{"size": 105400, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '32cceb02-a685-580e-93a6-8187a9c75cb8',
  'sermons',
  'series/54792132-3743-5d42-b3cc-832fac32a5bf/banner.jpg',
  NULL,
  NOW(), NOW(), NOW(),
  '{"size": 105400, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  '11aade93-f3fa-5429-a498-b520f551dd7a',
  'sermons',
  'series/a30746c2-de64-59b0-ad63-950f76a81593/banner.jpg',
  NULL,
  NOW(), NOW(), NOW(),
  '{"size": 105400, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)
VALUES (
  'dea5f4ec-62ea-5b4b-bbbf-a079c41abc69',
  'sermons',
  'series/d0132517-6870-5319-99dc-81812054687c/banner.jpg',
  NULL,
  NOW(), NOW(), NOW(),
  '{"size": 105400, "mimetype": "image/jpeg"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

