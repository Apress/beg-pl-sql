declare
  n_id              WORKER_T.id%TYPE             := 1;         
  n_worker_type_id  WORKER_T.worker_type_id%TYPE := 3;
  v_external_id     WORKER_T.external_id%TYPE    := '6305551212';       
  v_first_name      WORKER_T.first_name%TYPE     := 'JANE';        
  v_middle_name     WORKER_T.middle_name%TYPE    := 'E';       
  v_last_name       WORKER_T.last_name%TYPE      := 'DOE';         
  v_name            WORKER_T.name%TYPE           := 'JANEDOEE';              
  d_birth_date      WORKER_T.birth_date%TYPE     := 
    to_date('19800101', 'YYYYMMDD');        
  n_gender_id       WORKER_T.gender_id%TYPE      := 1;         
begin
  null;
end;
/
