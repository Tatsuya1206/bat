@ECHO OFF
@REM ##########################################
@REM �X�V����Ă��� .dll,.pdb,.aspx,.js���f�v���C
@REM ��1�����Fbin,pdb�t�@�C���̃f�v���C�L��
@REM        �@1�Fbin,pdb�t�@�C���̃f�v���C����
@REM        �@0�Fbin,pdb�t�@�C���̃f�v���C���Ȃ�
@REM ��2�����F�@�\ID
@REM ##########################################

@REM �R�s�[�� �f�B���N�g���ݒ�
SET SOURCE_DIR=
SET BIN_DIR=
SET FILE_DIR=

@REM �R�s�[�� �f�B���N�g���ݒ�
SET DESTINATION_DIR=
SET JS_DIR=

SET LOG_DIR=%~dp0\Log
SET SYS_DATE=%date:/=%
SET SYS_TIME=%time%
SET SYS_DATETIME=%SYS_DATE%_%SYS_TIME%
SET LOG_FILE=%SYS_DATE%.log

IF NOT EXIST %LOG_DIR% (
    MKDIR %LOG_DIR%
    TYPE NUL > %LOG_DIR%\%LOG_FILE%
)

:CHEACK_ARGS1
IF "%1"=="" (
    GOTO NO_ARGS1
) ELSE IF "%1"=="1" (
    GOTO CHEACK_ARGS2
) ELSE IF "%1"=="0" (
    GOTO CHEACK_ARGS2
) ELSE (
    GOTO NO_ARGS1
)

:CHEACK_ARGS2
IF "%2"=="" (
    GOTO :NO_ARGS2
) ELSE (
    @REM �����Ŏw�肳�ꂽ�@�\ID�̃t�@�C���̂ݑΏ�
    SET TARGET_ID=%2
    GOTO COPY_EXECUTE
)

:NO_ARGS1
ECHO.
ECHO ��1����
ECHO �u bin,pdb�t�@�C���̃f�v���C�L�� [1:�f�v���C����/0:�f�v���C���Ȃ�] �v
ECHO ���w�肵�āA�ēx�o�b�`�����s���Ă��������B
ECHO �������I�����܂��B
EXIT /B

:NO_ARGS2
SET /P fullDeploy="�S�t�@�C�����f�v���C���Ă�낵���ł����H[y�F�͂� / n�F������]" 
IF %fullDeploy:Y=Y%==Y (
    @REM �S�t�@�C���f�v���C���ėǂ��ꍇ
    SET TARGET_ID=*
    GOTO COPY_EXECUTE
) ELSE (
    @REM �S�f�v���C���Ȃ��ꍇ�́A�����I��
    ECHO.
    ECHO ��2����
    ECHO [�@�\ID]���w�肵�āA�ēx�o�b�`�����s���Ă��������B
    ECHO �������I�����܂��B
    EXIT /B
)

:COPY_EXECUTE
ECHO.
ECHO �f�v���C��...
ECHO. >> %LOG_DIR%\%LOG_FILE%
ECHO ############################## >> %LOG_DIR%\%LOG_FILE%
ECHO �f�v���C_%SYS_DATETIME% >> %LOG_DIR%\%LOG_FILE%
ECHO ############################## >> %LOG_DIR%\%LOG_FILE%

@REM dll,pdb �̃f�v���C
IF "%1"=="1" (
    ROBOCOPY %SOURCE_DIR%%BIN_DIR% %DESTINATION_DIR%%BIN_DIR% *.dll *.pdb >>%LOG_DIR%\%LOG_FILE% 2>&1
)
@REM aspx �̃f�v���C
FOR /R %SOURCE_DIR%%FILE_DIR% %%a IN (%TARGET_ID%.aspx) DO XCOPY %%a %DESTINATION_DIR% /Y /D >>%LOG_DIR%\%LOG_FILE% 2>&1
@REM js �̃f�v���C
FOR /R %SOURCE_DIR%%FILE_DIR% %%a IN (%TARGET_ID%.js) DO XCOPY %%a %DESTINATION_DIR%%JS_DIR% /Y /D >>%LOG_DIR%\%LOG_FILE% 2>&1

:END
ECHO.
ECHO �f�v���C�������܂����B