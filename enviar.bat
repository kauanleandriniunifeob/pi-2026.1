@echo off

git add .

set /p mensagem="O que voce alterou? (Ex: Corrigido bug de cor em botão, Adicionado funcionalidade de login): "

git commit -m "%mensagem%"

echo Enviando para o GitHub...
git push origin main

echo = TCommit enviado! =
pause