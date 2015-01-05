MyLinuxEnvironment
==================

Personal Linux Environment 

* Zsh profile
* Bash profile
* Vim profile


>여러 파일내(여기서는 html 파일)의 특정 문자열 한번에 치환하는 방법은
--
"
find ./ -name "*.html" -exec sed -i 's/old/new/g' {} \;
"
