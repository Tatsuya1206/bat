@ECHO OFF
@REM ##########################################
@REM Git初期設定バッチ
@REM .gitignoreファイルをbatのカレントディレクトリ
@REM に配置すること。
@REM ##########################################

SET CURRENT_DIR=%~dp0

@ECHO.
@ECHO ##########################################
@ECHO --処理開始
@ECHO ##########################################
@ECHO.

IF NOT EXIST .gitignore (
    @ECHO ##########################################
    @ECHO --実行条件エラー：
    @ECHO --.gitignoreファイルをGitInit.batの
    @ECHO --カレントディレクトリに配置してください。
    @ECHO.
    @ECHO --処理終了
    @ECHO ##########################################
    @ECHO.
    PAUSE
    EXIT /B 1
) 

@ECHO.
@ECHO ##########################################
@ECHO --１.リモートリポジトリ作成 
@ECHO ##########################################
MKDIR 00_RemoteRepository.git
CD ./00_RemoteRepository.git
git init --bare --shared

@ECHO.
@ECHO ##########################################
@ECHO --２.仮のローカルリポジトリ作成 
@ECHO ##########################################
CD ../
MKDIR 10_TmpLocalRepository
@REM masterブランチ作成用にignoreファイルを配置
MOVE .gitignore 10_TmpLocalRepository
CD 10_TmpLocalRepository
git init
git remote add origin ../00_RemoteRepository.git

@ECHO.
@ECHO ##########################################
@ECHO --３.masterブランチ作成
@ECHO ##########################################
git add .
git commit -m "masterブランチ作成"
git push --set-upstream origin master

@ECHO.
@ECHO ##########################################
@ECHO --４.各ブランチ作成
@ECHO --・develop ：開発用（派生元：master）
@ECHO --・feature ：機能追加用（派生元：develop）
@ECHO --・release ：リリース用（派生元：develop）
@ECHO --・hotfix  ：緊急対応用（派生元：master）
@ECHO --・support ：保守対応/軽微な修正用（派生元：master）
@ECHO ##########################################
git checkout -b develop master
git push -u origin develop
git checkout -b feature develop
git push -u origin feature
git checkout -b release develop
git push -u origin release
git checkout -b hotfix master
git push -u origin hotfix
git checkout -b support master
git push -u origin support

@ECHO.
@ECHO ##########################################
@ECHO --5.ブランチ状況確認
@ECHO ##########################################
git checkout master
git branch -a

@ECHO.
@ECHO ##########################################
@ECHO --処理終了
@ECHO ##########################################
@ECHO.

@ECHO.
PAUSE