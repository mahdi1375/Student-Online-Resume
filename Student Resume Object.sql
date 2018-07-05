CREATE TABLE  "EBA_DEMO_RESUME_COMMENTS" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"CHILD_ID" NUMBER, 
	"RESUME_ID" NUMBER NOT NULL ENABLE, 
	"COMMENT_TEXT" VARCHAR2(4000) NOT NULL ENABLE, 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255) NOT NULL ENABLE, 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(255) NOT NULL ENABLE, 
	 CONSTRAINT "EBA_DEMO_RESUME_COMMENTS_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "IR_RESUMEFILES" 
   (	"ID" NUMBER, 
	"ROW_VERSION_NUMBER" NUMBER, 
	"FILENAME" VARCHAR2(4000), 
	"FILE_MIMETYPE" VARCHAR2(512), 
	"FILE_CHARSET" VARCHAR2(512), 
	"FILE_BLOB" BLOB, 
	"FILE_COMMENTS" VARCHAR2(4000), 
	"TAGS" VARCHAR2(4000), 
	"CREATED" TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	"CREATED_BY" VARCHAR2(255), 
	"UPDATED" TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	"UPDATED_BY" VARCHAR2(255), 
	"PICTURE" BLOB, 
	 CONSTRAINT "IR_RESUMEFILES_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "IR_RESUMEFILES_UK1" UNIQUE ("CREATED_BY", "FILENAME")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "RS_MEMBER_ACC" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"NAME" VARCHAR2(20) NOT NULL ENABLE, 
	"FAMILY" VARCHAR2(20) NOT NULL ENABLE, 
	"CERTIFICATENUMBER" VARCHAR2(10) NOT NULL ENABLE, 
	"FATHERNAME" VARCHAR2(50), 
	"EMAIL" VARCHAR2(40) NOT NULL ENABLE, 
	"USER_NAME" VARCHAR2(50) NOT NULL ENABLE, 
	"PASSWORD" VARCHAR2(50) NOT NULL ENABLE, 
	"OLDPASS" VARCHAR2(50), 
	"REGISTERED" TIMESTAMP (6), 
	"VERIFIED" NUMBER(1,0), 
	"CREATED_BY" VARCHAR2(100), 
	"CREATED_DATE" DATE, 
	"MODIFIED_BY" VARCHAR2(100), 
	"MODIFIED_DATE" DATE, 
	"PASSWORD_SHOW" VARCHAR2(50) NOT NULL ENABLE, 
	"VIEW_NAME" NVARCHAR2(50), 
	"PHOTO_BLOB" BLOB, 
	 CONSTRAINT "RS_MEMBER_ACC_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "RS_MEMBER_ACC_UK1" UNIQUE ("USER_NAME", "EMAIL")
  USING INDEX  ENABLE
   )
/
CREATE INDEX  "EBA_DEMO_RESUME_COMMENT_IDX" ON  "EBA_DEMO_RESUME_COMMENTS" ("RESUME_ID")
/
CREATE OR REPLACE EDITIONABLE PACKAGE  "RESUME_PKG_REGISTER" as  
  
--============================================================  
-- function for hash password "GET_HASH"  
--============================================================  
   function "GET_HASH" (  
    "P_PASSWORD"            in varchar2  
   )  
   return varchar2;  
     
   --=============================================================  
   -- procedure for insert into table "CSP_USER"  
   --=============================================================  
   procedure "INS_USER" (  
      "P_NAME"              in varchar2,  
      "P_FAMILY"            in varchar2,  
      "P_USER_NAME"         in varchar2,  
      "P_PASSWORD"          in varchar2,  
      "P_EMAIL"             in varchar2  
   );  
     
   --=======================================================    
   -- update procedure for table "CSP_USER"  
   --=======================================================  
   procedure "UPD_USER" (  
      "P_USER_ID" in number,  
      "P_NAME"              in varchar2,  
      "P_FAMILY"            in varchar2,  
      "P_USER_NAME"         in varchar2,  
      "P_EMAIL"             in varchar2  
   );  
     
   --========================================================  
   -- delete procedure for table "CSP_USER"  
   --========================================================  
   procedure "DEL_USER" (  
      "P_USER_ID"           in number  
   );  
   --============================================================== 
   -- procedure for authenticat user "AUTHENTICATION"  
   --==============================================================  
   procedure  "AUTHENTICATION" ( 
       "P_USERNAME"         in varchar2,  
       "P_PASSWORD"         in varchar2, 
       "P_APP_ID"      IN NUMBER,
       "P_SESSION" IN NUMBER
   );  
  
   --=============================================================  
   -- procedure change password   
   --=============================================================  
   procedure "CHANGE_PASSWORD" (  
      "P_USER_NAME"         in varchar2,  
      "P_PASSWORD"          in varchar2  
   );  
     
end RESUME_PKG_REGISTER;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY  "RESUME_PKG_REGISTER" IS  
--========================================================  
-- function for hash password "GET_HASH"  
--========================================================  
   FUNCTION GET_HASH (P_PASSWORD    IN VARCHAR2)  
   RETURN VARCHAR2 IS  
   BEGIN  
    ---RAISE_APPLICATION_ERROR(-20123,'DD');  
    --  RETURN DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(P_PASSWORD),1);  
      RETURN P_PASSWORD;
   END; 
   
--========================================================  
-- procedure for insert into table "INS_CSP_USER"  
--========================================================  
   PROCEDURE "INS_USER" (  
      "P_NAME"              IN VARCHAR2,  
      "P_FAMILY"            IN VARCHAR2,  
      "P_USER_NAME"         IN VARCHAR2,  
      "P_PASSWORD"          IN VARCHAR2,  
      "P_EMAIL"             IN VARCHAR2  
   ) IS   
   BEGIN  
      INSERT INTO "RS_MEMBER_ACC" (  
         "NAME",  
         "FAMILY",  
         "USER_NAME",  
         "PASSWORD",  
         "EMAIL"  
      ) VALUES (   
         "P_NAME",  
         "P_FAMILY",  
         "P_USER_NAME",  
         GET_HASH(P_PASSWORD),  
         "P_EMAIL"  
      );  
      EXCEPTION   
          WHEN OTHERS THEN NULL;  
   END "INS_USER";  
--=======================================================    
-- update procedure for table "CSP_USER"  
--=======================================================  
   PROCEDURE "UPD_USER" (  
      "P_USER_ID" IN NUMBER,  
      "P_NAME"              IN VARCHAR2,  
      "P_FAMILY"            IN VARCHAR2,  
      "P_USER_NAME"         IN VARCHAR2,  
      "P_EMAIL"             IN VARCHAR2  
   ) IS   
   BEGIN  
     UPDATE "RS_MEMBER_ACC" SET  
            "ID"             = "P_USER_ID",  
            "NAME"                = "P_NAME",  
            "FAMILY"              = "P_FAMILY",  
            "USER_NAME"           = "P_USER_NAME",  
            "EMAIL"               = "P_EMAIL"  
     WHERE "ID" = "P_USER_ID";  
     
   END "UPD_USER";  
     
--========================================================  
-- delete procedure for table "CSP_USER"  
--========================================================  
   PROCEDURE "DEL_USER" (  
      "P_USER_ID" IN NUMBER  
   ) IS   
   
   BEGIN  
   
      DELETE FROM "RS_MEMBER_ACC"   
      WHERE "ID" = "P_USER_ID";  
   
   END "DEL_USER";  
   
--=========================================================  
-- function authenticate  
--=========================================================  
  PROCEDURE  "AUTHENTICATION" ("P_USERNAME"      IN VARCHAR2,  
                               "P_PASSWORD"      IN VARCHAR2, 
                               "P_APP_ID"      IN NUMBER,
                               "P_SESSION" IN NUMBER)  IS  
      
    L_PASSWORD        RS_MEMBER_ACC.PASSWORD%TYPE;  
    L_VALUE           PLS_INTEGER;  
    L_AUTH            PLS_INTEGER; 
    wrong_username_or_pass EXCEPTION; 
    BEGIN  
      L_PASSWORD := GET_HASH(P_PASSWORD);  
       
      BEGIN 
        SELECT 2  
          INTO L_VALUE  
          FROM RS_MEMBER_ACC  
         WHERE 1 = 1 AND  
               UPPER(RS_MEMBER_ACC.USER_NAME) = UPPER(P_USERNAME) AND  
               RS_MEMBER_ACC.PASSWORD_SHOW = GET_HASH(P_PASSWORD);  
        EXCEPTION  
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN  
             L_VALUE := 3;  
        WHEN OTHERS THEN  
             L_VALUE := 3;       
      END;  
      
      BEGIN 
        SELECT verified  
          INTO L_AUTH  
          FROM RS_MEMBER_ACC  
         WHERE 1 = 1 AND  
               UPPER(RS_MEMBER_ACC.USER_NAME) = UPPER(P_USERNAME) AND  
               RS_MEMBER_ACC.PASSWORD_SHOW = GET_HASH(P_PASSWORD);  
        EXCEPTION  
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN  
             L_AUTH := 3;  
        WHEN OTHERS THEN  
             L_AUTH := 3;       
      END;  
       
       
      IF L_VALUE = 2 and L_AUTH=1 THEN   
           --RETURN TRUE; 
           -- Redirect to Page 1 (Home Page). 
           Wwv_Flow_Custom_Auth_Std.POST_LOGIN(P_USERNAME -- p_User_Name 
                                           ,L_PASSWORD -- p_Password 
                                           ,v('APP_SESSION') -- p_Session_Id 
                                           ,P_APP_ID || ':51' -- p_Flow_page 
                                            ); 
          /* apex_custom_auth.login(
                      p_uname => P_USERNAME,
                      p_password => L_PASSWORD,
                      p_app_page => P_APP_ID || ':51'
                      );*/
                                 
      ELSE if L_VALUE != 2 and L_AUTH != 1 then  
           --RETURN FALSE;  
            -- Login Failure, redirect to page 101 (Login Page). 
          Owa_Util.Redirect_Url('f?p='||P_APP_ID||':101:'||v('APP_SESSION')); 
          --apex_application.g_print_success_message := '<span style="color: red;">Username or password is wrong or your username not verified yet.</span>'; 
          APEX_ERROR.ADD_ERROR(
              p_message            => 'نام کاربری یا رمز عبور درست وارد نشده است.',
              p_display_location   => apex_error.c_inline_in_notification 
          ); 
      ELSE IF L_VALUE = 2 and L_AUTH!=1 THEN   
          APEX_ERROR.ADD_ERROR(
              p_message            => 'کاربر محترم وضعیت فعلی شما غیر فعال می باشد.',
              p_display_location   => apex_error.c_inline_in_notification 
          ); 
      end if; 
      end if; 
          --RAISE_APPLICATION_ERROR(-20001,'Username or password is wrong'); 
          --RAISE wrong_username_or_pass; 
    END IF; 
     
    EXCEPTION  
       WHEN wrong_username_or_pass THEN 
              RAISE_APPLICATION_ERROR(-20001,'Username or password is wrong'); 
       WHEN OTHERS THEN 
              raise_application_error(-20002,'An error has occurred.'); 
    END "AUTHENTICATION"; 
  
--========================================================  
-- procedure "CHANGE_PASSWORD"  
--========================================================  
   PROCEDURE "CHANGE_PASSWORD" (  
      "P_USER_NAME"         IN VARCHAR2,  
      "P_PASSWORD"          IN VARCHAR2  
   ) IS   
   BEGIN  
                    ---RAISE_APPLICATION_ERROR(-20123,P_USER_NAME);  
      UPDATE RS_MEMBER_ACC   
         SET PASSWORD = GET_HASH(P_PASSWORD),  
             VERIFIED = 1,  
             REGISTERED = SYSDATE  
      WHERE USER_NAME = P_USER_NAME;  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
   END "CHANGE_PASSWORD";  
--========================================================  
END RESUME_PKG_REGISTER;
/

 CREATE SEQUENCE   "RS_MEMBER_ACC_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 14 NOCACHE  NOORDER  NOCYCLE  NOPARTITION
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BIU_EBA_DEMO_RESUMEH_COMMENTS" 
    before insert or update on eba_demo_resume_comments
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    if inserting then
        :new.created    := localtimestamp;
        :new.created_by := nvl(wwv_flow.g_user,user);
    end if;
    :new.updated    := localtimestamp;
    :new.updated_by := nvl(wwv_flow.g_user,user);
end;

/
ALTER TRIGGER  "BIU_EBA_DEMO_RESUMEH_COMMENTS" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "IR_RESUMEFILES_BD" 
    before delete on IR_RESUMEFILES
    for each row
begin
    eba_cust_fw.tag_sync(
        p_new_tags      => null,
        p_old_tags      => :old.tags,
        p_content_type  => 'FILE',
        p_content_id    => :old.id );
end;

/
ALTER TRIGGER  "IR_RESUMEFILES_BD" DISABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "IR_RESUMEFILES_BIU" 
  before insert or update on IR_RESUMEFILES
  for each row
begin
  if (inserting or updating) and nvl(dbms_lob.getlength(:new.file_blob),0) > 15728640 then
    raise_application_error(-20000, 'انداره فایل بیشتر از 15 مگابایت می باشد. لطفا یک فایل کم حجم تر را آپلود کنید');
  end if;
  if inserting then
    if :NEW.ID is null then
      select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
        into :new.id
        from dual;
    end if;
    :NEW.CREATED := localtimestamp;
    :NEW.CREATED_BY := nvl(v('APP_USER'),USER);
    :NEW.UPDATED := localtimestamp;
    :NEW.UPDATED_BY := nvl(v('APP_USER'),USER);
    :new.row_version_number := 1;
  end if;
  if updating then
    :NEW.UPDATED := localtimestamp;
    :NEW.UPDATED_BY := nvl(v('APP_USER'),USER);
    :new.row_version_number := nvl(:new.row_version_number,0) + 1;
  end if;
  /*eba_cust_fw.tag_sync(
    p_new_tags      => :new.tags,
    p_old_tags      => :old.tags,
    p_content_type  => 'FILE',
    p_content_id    => :new.id );*/
end;

/
ALTER TRIGGER  "IR_RESUMEFILES_BIU" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "RS_MEMEBER_ACC_BI" 
BEFORE INSERT or UPDATE ON RS_MEMBER_ACC for each row
declare
oldp varchar2(50);
BEGIN
    
  IF INSERTING THEN  
  :NEW.ID       := RS_MEMBER_ACC_SEQ.NEXTVAL; 
  :NEW.CREATED_BY    := V('APP_USER'); 
  :NEW.CREATED_DATE  := SYSDATE; 
  :NEW.USER_NAME     :=UPPER(:NEW.USER_NAME); 
  :NEW.PASSWORD     := RS_PKG_REGISTER.GET_HASH(:NEW.PASSWORD_SHOW);
END IF; 
 
IF UPDATING THEN   
  --select password into oldp from RS_MEMBER_ACC where id=v('ID');
  :NEW.MODIFIED_BY    := V('APP_USER'); 
  :NEW.MODIFIED_DATE  := SYSDATE; 
  :NEW.USER_NAME      :=UPPER(:NEW.USER_NAME); 
  :NEW.OLDPASS        := :old.password ;
  :NEW.PASSWORD     := RS_PKG_REGISTER.GET_HASH(:NEW.PASSWORD_SHOW);
END IF;     
END;

/
ALTER TRIGGER  "RS_MEMEBER_ACC_BI" ENABLE
/
