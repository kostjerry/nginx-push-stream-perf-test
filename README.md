# nginx-push-stream-module performance test

1. docker-compose up --build

2. open http://localhost:8080/ and open developer console

3. run pub.sh -- it will publish to the channel a 300k-portion of data each 3 seconds

4. run sub.sh -- it will create 500 subscribers to the test channel

5. investigate delays after page reload

