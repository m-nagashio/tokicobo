# gcc -fPIC -c sentiment-analysis.c sentiment-analysis-rest-client.c string-utils.c  -I/usr/include -lcurl -ljson-c
# cobc -x debug.cbl sentiment-analysis.o sentiment-analysis-rest-client.o string-utils.o -I/usr/local/include -I/usr/include -L/usr/local/lib -L/usr/lib -lcurl -ljson-c
# ./debug

gcc -fPIC -c sentiment-analysis.c sentiment-analysis-rest-client.c string-utils.c -I/usr/include -lcurl -ljson-c
cobc -x MAIN.cob STORY.cob POSI.cob NEGA.cob sentiment-analysis.o sentiment-analysis-rest-client.o string-utils.o -I/usr/local/include -I/usr/include -L/usr/local/lib -L/usr/lib -lcurl -ljson-c
./MAIN
