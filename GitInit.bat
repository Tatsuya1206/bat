@ECHO OFF
@REM ##########################################
@REM Git�����ݒ�o�b�`
@REM .gitignore�t�@�C����bat�̃J�����g�f�B���N�g��
@REM �ɔz�u���邱�ƁB
@REM ##########################################

SET CURRENT_DIR=%~dp0

@ECHO.
@ECHO ##########################################
@ECHO --�����J�n
@ECHO ##########################################
@ECHO.

IF NOT EXIST .gitignore (
    @ECHO ##########################################
    @ECHO --���s�����G���[�F
    @ECHO --.gitignore�t�@�C����GitInit.bat��
    @ECHO --�J�����g�f�B���N�g���ɔz�u���Ă��������B
    @ECHO.
    @ECHO --�����I��
    @ECHO ##########################################
    @ECHO.
    PAUSE
    EXIT /B 1
) 

@ECHO.
@ECHO ##########################################
@ECHO --�P.�����[�g���|�W�g���쐬 
@ECHO ##########################################
MKDIR 00_RemoteRepository.git
CD ./00_RemoteRepository.git
git init --bare --shared

@ECHO.
@ECHO ##########################################
@ECHO --�Q.���̃��[�J�����|�W�g���쐬 
@ECHO ##########################################
CD ../
MKDIR 10_TmpLocalRepository
@REM master�u�����`�쐬�p��ignore�t�@�C����z�u
MOVE .gitignore 10_TmpLocalRepository
CD 10_TmpLocalRepository
git init
git remote add origin ../00_RemoteRepository.git

@ECHO.
@ECHO ##########################################
@ECHO --�R.master�u�����`�쐬
@ECHO ##########################################
git add .
git commit -m "master�u�����`�쐬"
git push --set-upstream origin master

@ECHO.
@ECHO ##########################################
@ECHO --�S.�e�u�����`�쐬
@ECHO --�Edevelop �F�J���p�i�h�����Fmaster�j
@ECHO --�Efeature �F�@�\�ǉ��p�i�h�����Fdevelop�j
@ECHO --�Erelease �F�����[�X�p�i�h�����Fdevelop�j
@ECHO --�Ehotfix  �F�ً}�Ή��p�i�h�����Fmaster�j
@ECHO --�Esupport �F�ێ�Ή�/�y���ȏC���p�i�h�����Fmaster�j
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
@ECHO --5.�u�����`�󋵊m�F
@ECHO ##########################################
git checkout master
git branch -a

@ECHO.
@ECHO ##########################################
@ECHO --�����I��
@ECHO ##########################################
@ECHO.

@ECHO.
PAUSE