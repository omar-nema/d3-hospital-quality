
select count(*) from ( 

SELECT
     
   NULL AS center_id
     , CAST(o.seq_no AS VARCHAR(50)) AS order_id
     , CAST(o.person_id AS VARCHAR(50)) AS patient_id
     , CAST(o.encounterID AS VARCHAR(50)) AS encounter_id
     , CAST(e.rendering_provider_id AS VARCHAR(50)) AS ordering_provider_id
     , CAST(lm.location_name AS VARCHAR(50)) AS from_location_id
     , NULL AS to_location_id
     , CAST(COALESCE(o.actTextDisplay,o.actText) AS VARCHAR(50)) AS order_name
     , NULL AS order_notes 
     , NULL AS order_priority
     , CAST(o.actStatus AS VARCHAR(50)) AS order_status
     , CAST(o.actClass AS VARCHAR(50)) AS order_type 
     , NULL AS order_specialty_unscrubbed
     , CAST(o.actCode AS VARCHAR(50)) AS cpt_code 
     , CAST(o.actDiagnosisCode AS VARCHAR(50)) AS icd9_code
     , NULL AS icd10_code
     , CASE WHEN ISNUMERIC(o.actSequenceNum) = 1 
      THEN CASE
          WHEN (o.actSequenceNum like '%.%' or o.actSequenceNum like '%,%')
          THEN NULL 
          ELSE CAST(o.actSequenceNum AS VARCHAR(50)) 
         END
      ELSE NULL
     END AS sequence_number
     ,  CASE WHEN ISDATE(COALESCE(o.receivedDate, o.completedDate)) = 1 
            THEN CONVERT(VARCHAR, CAST(COALESCE(o.receivedDate, o.completedDate) AS datetime), 20) 
            ELSE NULL END AS result_received_date 
     , NULL AS reviewing_provider_id
     , NULL AS result_reviewed_date
     , CASE WHEN o.cancelled = '1' THEN '1'
            WHEN o.deleted = '1' THEN '1'
            ELSE '0' END AS delete_ind 
     , CONVERT(VARCHAR, COALESCE(o.create_timestamp, o.modify_timestamp), 20) AS create_timestamp
     , CONVERT(VARCHAR, COALESCE(o.modify_timestamp, o.create_timestamp), 20) AS modify_timestamp
     , ?LoadedFromFile? AS loaded_from_file
     , NULL AS created_by
     , NULL AS modified_by
     , '1' AS cpoe_ind
     , NULL AS linked_image_ind
FROM order_ o 
LEFT JOIN patient_encounter e
    ON o.encounterID = e.enc_id
LEFT JOIN location_mstr lm 
    ON e.location_id = lm.location_id      
--WHERE o.practice_id IN (~PracticeID~)

)

) a1
-- AND COALESCE(o.modify_timestamp, o.create_timestamp) >= ?Lower_Bound?
-- AND COALESCE(o.modify_timestamp, o.create_timestamp) <= ?Upper_Bound?
-- AND (ISDATE(o.ordereddate)=1 or ISDATE(o.completedDate)=1)
