@ECHO OFF
@REM ##########################################
@REM 更新されている .dll,.pdb,.aspx,.jsをデプロイ
@REM 第1引数：bin,pdbファイルのデプロイ有無
@REM        　1：bin,pdbファイルのデプロイする
@REM        　0：bin,pdbファイルのデプロイしない
@REM 第2引数：機能ID
@REM ##########################################

@REM コピー元 ディレクトリ設定
SET SOURCE_DIR=
SET BIN_DIR=
SET FILE_DIR=

@REM コピー先 ディレクトリ設定
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
    @REM 引数で指定された機能IDのファイルのみ対象
    SET TARGET_ID=%2
    GOTO COPY_EXECUTE
)

:NO_ARGS1
ECHO.
ECHO 第1引数
ECHO 「 bin,pdbファイルのデプロイ有無 [1:デプロイする/0:デプロイしない] 」
ECHO を指定して、再度バッチを実行してください。
ECHO 処理を終了します。
EXIT /B

:NO_ARGS2
SET /P fullDeploy="全ファイルをデプロイしてよろしいですか？[y：はい / n：いいえ]" 
IF %fullDeploy:Y=Y%==Y (
    @REM 全ファイルデプロイして良い場合
    SET TARGET_ID=*
    GOTO COPY_EXECUTE
) ELSE (
    @REM 全デプロイしない場合は、処理終了
    ECHO.
    ECHO 第2引数
    ECHO [機能ID]を指定して、再度バッチを実行してください。
    ECHO 処理を終了します。
    EXIT /B
)

:COPY_EXECUTE
ECHO.
ECHO デプロイ中...
ECHO. >> %LOG_DIR%\%LOG_FILE%
ECHO ############################## >> %LOG_DIR%\%LOG_FILE%
ECHO デプロイ_%SYS_DATETIME% >> %LOG_DIR%\%LOG_FILE%
ECHO ############################## >> %LOG_DIR%\%LOG_FILE%

@REM dll,pdb のデプロイ
IF "%1"=="1" (
    ROBOCOPY %SOURCE_DIR%%BIN_DIR% %DESTINATION_DIR%%BIN_DIR% *.dll *.pdb >>%LOG_DIR%\%LOG_FILE% 2>&1
)
@REM aspx のデプロイ
FOR /R %SOURCE_DIR%%FILE_DIR% %%a IN (%TARGET_ID%.aspx) DO XCOPY %%a %DESTINATION_DIR% /Y /D >>%LOG_DIR%\%LOG_FILE% 2>&1
@REM js のデプロイ
FOR /R %SOURCE_DIR%%FILE_DIR% %%a IN (%TARGET_ID%.js) DO XCOPY %%a %DESTINATION_DIR%%JS_DIR% /Y /D >>%LOG_DIR%\%LOG_FILE% 2>&1

:END
ECHO.
ECHO デプロイ完了しました。