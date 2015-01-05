#!/bin/bash

# 현재 디렉토리에 들어 있는 파일중, 이름에 정상적이지 않은 글자가 포함된 파일을 지우기

for filename in *
do
badname=`echo "$filename" | sed -n /[\+\{\;\"\\\=\?~\(\)\<\>\&\*\|\$]/p`
# 이런 고약한 글자를 포함하는 파일들: + { ; " \ = ? ~ ( ) < > & * | $
	rm $badname 2>/dev/null    # 에러 메세지는 무시.
done

# 다음은 모든 종류의 공백 문자를 포함하는 파일들을 처리하겠습니다.
find . -name "* *" -exec rm -f {} \;
# "find"가 찾은 파일이름이 "{}"로 바뀝니다.
# '\'를 써서 ';'가 명령어 끝을 나타낸다는 원래의 의미로 해석되게 합니다.

exit 0

#---------------------------------------------------------------------
# 다음의 명령어들은 위에서 "exit"를 했기 때문에 실행되지 않습니다.

# 위 스크립트의 다른 방법:
find . -name '*[+{;"\\=?~()<>&*|$ ]*' -exec rm -f '{}' \;
exit 0
# (Thanks, S.C.)
