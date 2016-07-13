SELECT
    ?DBID? as center_id
    , p.IMREPROV_CODE as provider_id
    , p.Prov_FirstName as first_name
    , p.Prov_LastName as last_name
    , a.ADDR_EMAILADDRESS as email
    , a.ADDR_ADDRESS as address1
    , null as address2
    , a.ADDR_CITY as city
    , a.ADDR_STATE as state
    , a.ADDR_ZIP as zip
    , a.ADDR_PHONE as phone
    , PROVTYPE.DICT_Description as type
    , p.NPI as national_provider_id
    , null as taxonomy_code
    , CONVERT(VARCHAR, p.TAG_SYSTEMDATE, 20) as create_timestamp
    , CASE WHEN p.TAG_ARCHIVED = 1 THEN '1' ELSE '0' END as delete_ind
    , CASE WHEN SPEC.DESCRIPTION IS NOT NULL 
		THEN SPEC.DESCRIPTION
		ELSE 'Unassigned'
	  END AS specialty 
    , CONVERT(VARCHAR, p.TAG_SYSTEMDATE, 20) as modify_timestamp
    , ?LoadedFromFile? AS loaded_from_file
    , p.PROV_MIDDLEINITIAL AS middle_name 
    , l.LOCATION_NAME AS usual_location
	, CASE WHEN p.TAG_ARCHIVED = 1 THEN '0' ELSE '1' END AS prov_active_ind
	
FROM ~EmrDBName~.hpsite.providers p
INNER JOIN ~NtierDBName~.pm.Practitioners PRAC
	ON PRAC.Abbreviation = p.PROV_ID
LEFT JOIN ~NtierDBName~.pm.Specialties SPEC
	ON PRAC.Specialty_ID=SPEC.Specialty_ID
LEFT JOIN ~EmrDBName~.hpsite.Addresses a
	ON a.IMREADDR_CODE = p.Prov_AddrCode
LEFT JOIN ~EmrDBName~.hpsystem.DICTIONARIES_MASTER PROVTYPE
	ON PROVTYPE.DICT_CODE = p.prov_type
	AND PROVTYPE.dict_type = 'PROID'
LEFT JOIN ~EmrDBName~.hpsystem.DICTIONARIES_MASTER PROVSPEC
	ON PROVSPEC.DICT_CODE = p.prov_specialty
	AND PROVSPEC.dict_type = 'PROSPE'
LEFT JOIN ~EmrDBName~.hpsite.location l
	ON p.PROV_ADDRCODE = l.IMREADDR_CODE
WHERE COALESCE(p.TAG_SYSTEMDATE, getdate()) >= ?Lower_Bound?
AND COALESCE(p.TAG_SYSTEMDATE, getdate()) <= ?Upper_Bound?

~OtherParam~
