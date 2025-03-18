# redis는 0~15번까지의 database로 구성
select db번호

# 데이터베이스 내 모든 키 조회
keys *

# 일반적인 String 구조
# set을 통해 key:value 세팅
set user:email:1 hong1@naver.com
# nx : 이미 존재하면 pass, 없으면 set
set user:email:2 hong2@naver.com nx
# ex : 만료 시간 지정(초단위) , ttl(time to live)
set user:email:3 hong3@naver.com ex 10
# EXRIRE key값 만료시간 : ex를 설정하지 않았을 때에 별도 부여도 가능
EXRIRE dkowadkowa 3600

# 실무 활용법 
# redis활용 : 사용자 인증정보 저장(ex-refresh토큰)
set user:1:refresh_token evjaxballsdks ex 100000 # 난수 값

# 보통 아이디나 비밀번호를 RDB에 넣어 Redis에서 토큰을 발급해 인증을 하게 하는 편이다.
# 액세스 토큰(AT) : 유효기간이 짧은 걸로 이루어져 있는 토큰.
# refresh 토큰(RT) : 유효기간이 긴 토큰
# Redis를 사용하는 이유 : 기본적으로 RDB보다 조회속도가 빨라 유저들이 빈번하게 사용하는 경우 Redis를 사용한다.

# 특정 key 삭제
del user:email:1
# 현재 DB내 모든 key삭제
flushdb

# redis활용 : 좋아요기능 구현
# RDB -> 동시성 이슈 가능성 있음. 이유 : 멀티스레드를 지원하기에. 다만 Redis는 싱글스레드를 지원.
set likes:posting:1 0
incr likes:posting:1 #특정 key값의 value를 1만큼 증가.
decr likes:posting:1 #특정 key값의 value를 1만큼 감소.
get likes:posting:1

# redis활용 : 재고관리
set stocks:product:1 100
decr stocks:product:1
get stocks:product:1

# redis활용 : 캐싱(임시 저장) 기능 구현
set posting:1 "{\"title\":\"hello java\", \"contents\":\"hello java is ...\" , \"author_email\":\"hong@naver.com\"}" ex 100

# list자료구조 : redis의 list는 deque자료구조
# lpush : 데이터를 왼쪽 끝에 삽입
# rpush : 데이터를 오른쪽 끝에 삽입
# lpop : 데이터를 왼쪽에서 꺼내기
# rpop : 데이터를 오른쪽에서 꺼내기

lpush honglidongs hong1 # 맨 왼쪽
lpush honglidongs hong2 # 맨 왼쪽 2번째
rpush honglidongs hong3 # 맨 오른쪽
lrange honglidongs 0 -1 # 시작과 끝
rpop honglidongs # rpop 하는 경우 lrange에서 나오지 않는다. 이유는 꺼냈기 때문에
lpop honglidongs # 이것도 동일

# list 조회
# -1은 리스트의 끝자리(마지막 index)를 의미, -2는 끝에서 2번째를 의미
lrange honglidongs 0 0 # 첫번째 값 조회
lrange honglidongs -1 -1 # 마지막 값만 조회
lrange honglidongs 0 -1 # 처음부터 끝까지
lrange honglidongs -2 -1 # 마지막 2번째부터 마지막 자리까지 조회
lrange honglidongs 0 1 #처음부터 2번째까지

# 데이터 개수 조회
llen honglidongs
# ttl 적용
expire honglidongs 20
# ttl 조회
ttl honglidongs

# redis 활용 : 최근 방문한 페이지, 최근 조회한 상품목록
rpush mypages www.naver.com
rpush mypages www.gogle.com
rpush mypages www.daum.net
rpush mypages www.chatgpt.com
rpush mypages www.daum.net
# 최근 방문한 페이지 3개만 보여주는
lrange mypages -3 -1
