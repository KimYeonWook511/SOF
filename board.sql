-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: board
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `no` int NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `addr` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `content` varchar(5000) DEFAULT NULL,
  `writer` varchar(20) DEFAULT NULL,
  `writeDate` date DEFAULT NULL,
  `viewCount` int DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` VALUES (1,'우리 동네 맛집 계절향기를 소개합니다!','인천광역시 계양구 계양문화로 19','일식, 돈까스, 모밀, 덮밥','6000원 ~ 12000원','이번에 저희 동네에 숨어 있던 맛집을 하나 발견했습니다!\r\n바로바로~~~ 계절향기라는 곳인데요?\r\n가자마자 해당 주소 건물 2층으로 올라가면 바로 보입니다!\r\n입구는 일식 집 느낌이 폴폴 풍기는 형태로 되어있으며, 내부 좌석은 8팀정도? 올 수 있을 거 같습니당!\r\n저는 이번에 연어 덮밥과 친구는 치즈 돈까스를 시켜서 먹었는데 양도 푸짐하고 맛도 정말 보장합니다!\r\n분위기도 좋고 맛도 챙기는 이 맛집 한번 가보시는 걸 추천드립니다!','suyoung','2021-12-12',16),(2,'갬성 카페 HOWAREYOU','인천 계양구 까치말로49번길 5-1','카페, 디저트','3800원 ~ 5900원','조용하면서도 분위기 있는 카페를 원한다면 추천합니다.\r\n상당히 맛있는 여러 종류의 커피들과 스무디, 쉐이크 등등 여러가지 있습니다.\r\n그리고 컵케이크도 상당히 인상적으로 맛있습니다.\r\n적극 추천하는 작전동 카페입니다!','shali','2021-12-12',10),(3,'작전역 원조기계우동','인천광역시 계양구 봉오대로 659','우동, 소바','2000원 ~ 5500원','진짜 숨은 우동 맛집입니다\r\n가보세요 한번','root','2021-12-12',0),(4,'서울 서래마을 maillet 카페','서울 서초구 사평대로22길 14','카페, 디저트','5000원 ~ 10000원','그냥 괜찮아요','root','2021-12-12',0),(5,'철인7호 사상점','부산광역시 사상구 광장로81번길 51','치킨, 닭강정, 맥주','15900원 ~ 19900원','치맥하기 좋은 집\r\n추천합니다~','root','2021-12-12',0),(6,'가성비의 미도방만두','인천광역시 계양구 효서로 360','칼국수, 김밥, 만두','2000원 ~ 3000원','진짜 가성비의 끝판왕 칼국수가 2900원입니다.\r\n맛도 보장해요 정말 맛있습니다.\r\n어머니도 너무 친절하셔요ㅠㅠ','root','2021-12-12',2),(7,'동네 용해루','인천 계양구 까치말로 22','중식','5000원 ~ 10000원','괜찮네요','root','2021-12-12',0),(8,'작전동의 순대국 자랑!! \"부부순대국\"','인천 계양구 까치말로 16','순대, 순댓국','8000원 ~ 18000원','순대국도 맛있고 순대전골도 장난아니에요...\r\n적극 추천합니당','root','2021-12-12',4),(9,'부평 3층 카페, 아날로그','인천 부평구 부평대로40번길 4-1','카페, 디저트','3500원 ~ 8000원','아메리카노 원두를 다양하게 선택할 수 있고, 크레이프도 정말 맛있어요.\r\n음료도 다양하게 있으니 한 번쯤 가보시는 것도 추천합니당','root','2021-12-12',7),(10,'인하대 후문 한식 맛집(삼삼오오)','인천광역시 미추홀구 인하로 83','한식, 김치찌개, 불고기','6000원 ~ 6500원','인하공전 학생입니다\r\n매번 수업 끝나고 점심시간 혹은 저녁시간때 학우들과 식사하러 삼삼오오를 주로 갑니다\r\n진짜 무한 리필 떡볶이도 너무 맛있고 생고기 김치찌개 필수입니다.. 정말 너무 맛있어요!\r\n여러분들도 꼭 가보세요!!','root','2021-12-12',9);
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `boardimg`
--

DROP TABLE IF EXISTS `boardimg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `boardimg` (
  `no` int DEFAULT NULL,
  `fileRealName` varchar(100) DEFAULT NULL,
  `imgNo` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boardimg`
--

LOCK TABLES `boardimg` WRITE;
/*!40000 ALTER TABLE `boardimg` DISABLE KEYS */;
INSERT INTO `boardimg` VALUES (1,NULL,5),(1,'eraaerg.jfif',4),(1,'asefxfv.jfif',3),(1,'zgrgr.jfif',2),(1,'qwetas.jfif',1),(2,NULL,5),(2,NULL,4),(2,NULL,3),(2,'13513.jfif',2),(2,NULL,1),(3,NULL,5),(3,NULL,4),(3,NULL,3),(3,NULL,2),(3,NULL,1),(4,NULL,5),(4,NULL,4),(4,NULL,3),(4,NULL,2),(4,NULL,1),(5,NULL,5),(5,NULL,4),(5,'dxfv.jfif',3),(5,NULL,2),(5,NULL,1),(6,NULL,5),(6,NULL,4),(6,NULL,3),(6,'asegw.jfif',2),(6,'asdge.jfif',1),(7,NULL,5),(7,NULL,4),(7,NULL,3),(7,NULL,2),(7,NULL,1),(8,NULL,5),(8,'1315.jfif',4),(8,'34f34.jfif',3),(8,'fa4f4.jfif',2),(8,'a4a44a4f.jfif',1),(9,NULL,5),(9,'asf234234f.jfif',4),(9,'2ef2ef.jfif',3),(9,'asfe3223.jfif',2),(9,'2ef2f2ed.jfif',1),(10,NULL,5),(10,NULL,4),(10,'zfer23.jfif',3),(10,'asefwef2.jfif',2),(10,'23f23f.jfif',1);
/*!40000 ALTER TABLE `boardimg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `no` int NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `addr` varchar(50) DEFAULT NULL,
  `phoneNumber` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `businessTime` varchar(50) DEFAULT NULL,
  `breakTime` varchar(50) DEFAULT NULL,
  `updateTime` date DEFAULT NULL,
  `registerTime` datetime DEFAULT NULL,
  `viewCount` int DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (1,'금문도','인천광역시 계양구 효서로 268 금문도','032-544-6665','짜장면, 짬뽕, 중식','6000원 ~ 10000원','매일 11:00 ~ 21:30','없음','2021-12-12','2021-12-12 15:12:43',27),(2,'차이홍','인천광역시 연수구 센트럴로 123 차이홍','0507-1482-0112','짜장면, 탕수육, 양장피, 중식','8000원 ~ 25000원','매일 11:00 ~ 22:00','평일 15:00 ~ 17:00','2021-12-12','2021-12-12 15:21:46',3),(3,'쉐이크쉑 송도점','인천광역시 연수구 송도과학로 16번길 33-2','032-310-9464','햄버거, 쉐이크, 수제버거','6900원 ~ 11900원','평일 11:00 ~ 22:00, 주말 10:30 ~ 22:00','없음','2021-12-12','2021-12-12 15:27:49',19),(4,'비스타 워커힐 서울 피자힐','서울특별시 광진구 워커힐로 177 워커힐 호텔앤리조트','02-450-4699','피자, 샐러드','24000원 ~ 79000원','매일 11:30 ~ 22:00 (90분 간격 총 7부제)','없음','2021-12-12','2021-12-12 15:37:36',2),(5,'마조레','부산광역시 연제구 거제시장로11번길 21','051-852-9822','양식, 피자, 샐러드','26000원','매일 11:30 ~ 21:30','없음','2021-12-12','2021-12-12 15:39:28',5),(6,'순대고을','충청북도 영동군 영동읍 영동시장1길 41 사무소','043-745-0058','국밥, 순대국밥','6000원 ~ 15000원','매일 08:00 ~ 21:00','없음','2021-12-12','2021-12-12 15:43:47',2),(7,'MAHE','전라남도 여수시 화정면 화백길 6 마애','0507-1390-7541','카페, 디저트','6500원','매일 09:00 ~ 20:00 | 라스트 오더 19:30','없음','2021-12-12','2021-12-12 17:38:56',7),(8,'소울브릿지','강원도 고성군 토성면 천진해변길 33','0507-1310-2300','카페, 디저트, 브런치','6000원 ~ 18000원','평일 09:00 ~ 17:00, 주말 09:00 ~ 18:00','없음','2021-12-12','2021-12-12 17:48:09',4);
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurantimg`
--

DROP TABLE IF EXISTS `restaurantimg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurantimg` (
  `no` int DEFAULT NULL,
  `fileRealName` varchar(100) DEFAULT NULL,
  `imgNo` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurantimg`
--

LOCK TABLES `restaurantimg` WRITE;
/*!40000 ALTER TABLE `restaurantimg` DISABLE KEYS */;
INSERT INTO `restaurantimg` VALUES (1,'메뉴.jfif',5),(1,'탕수육.jfif',4),(1,'짜장면.jfif',3),(1,'내부.jfif',2),(1,'외부.jfif',1),(2,NULL,5),(2,'팔보채.jfif',4),(2,'자장면.jfif',3),(2,'메뉴판.jfif',2),(2,'간판.jfif',1),(3,'쉑메뉴.jfif',5),(3,'내부인파.jfif',4),(3,'qjrj.jfif',3),(3,'갬성.jfif',2),(3,'쉨외부.jfif',1),(4,'zvs.jfif',5),(4,'sease.jfif',4),(4,'빜티.jfif',3),(4,'vndzdf.jfif',2),(4,'er.jfif',1),(5,'qerh.jfif',5),(5,'qhh.jfif',4),(5,'wqf.jfif',3),(5,'zg.jfif',2),(5,'zxvxdf.jfif',1),(6,'asdfeq.jfif',5),(6,'zvzv.jfif',4),(6,'asfeq.jfif',3),(6,'zvvz.jfif',2),(6,'qwef.jfif',1),(7,'zxfgger.jfif',5),(7,'zfw.jfif',4),(7,'qwff.jfif',3),(7,'qhqebt.jfif',2),(7,'asef.jfif',1),(8,'vrer1.jfif',5),(8,'asfdwe.jfif',4),(8,'qwegrfg.jfif',3),(8,'qwrgzxfg.jfif',2),(8,'vrer.jfif',1);
/*!40000 ALTER TABLE `restaurantimg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurantlike`
--

DROP TABLE IF EXISTS `restaurantlike`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurantlike` (
  `no` int DEFAULT NULL,
  `userID` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurantlike`
--

LOCK TABLES `restaurantlike` WRITE;
/*!40000 ALTER TABLE `restaurantlike` DISABLE KEYS */;
INSERT INTO `restaurantlike` VALUES (1,'root'),(3,'guest'),(3,'root'),(7,'root'),(7,'duddn'),(1,'duddn'),(3,'duddn'),(8,'root'),(8,'suyoung');
/*!40000 ALTER TABLE `restaurantlike` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `no` int NOT NULL,
  `restNo` int DEFAULT NULL,
  `title` varchar(300) DEFAULT NULL,
  `content` varchar(5000) DEFAULT NULL,
  `writer` varchar(20) DEFAULT NULL,
  `writeDate` date DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,1,'너무 친절하고 좋았어요','음식도 맛있고 정말 친절했어요','root','2021-12-12'),(2,2,'다음에 또 와야겠어요!','너무 맛있었습니다.\r\n특히 유니 짜장면이 정말 대박이에요~','root','2021-12-12'),(3,3,'이게 송도 감성..?','너무 좋았습니다..\r\n햄버거도 맛있고, 쉐이크를 곁들여서 먹는 감자튀김은 진짜 미쳤어요...\r\n그리고 무슨 쿠폰을 주는데 다음에 또 오면 아이스크림이 공짜래요!!\r\n완전 혜자~ 굿 추천합니당','dmdkdk','2021-12-12'),(4,3,'행복..','너무 좋았음','guest','2021-12-12'),(5,7,'여수 갬성 카페','커피도 디저트도 너무 맛있어요!!\r\n심지어 주변 배경도 너무 좋아서 데이트 장소로 정말 좋았어요\r\n그리고 포토존도 많아서 사진을 정말 한 무더기 찍었답니다~','duddn','2021-12-12');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviewimg`
--

DROP TABLE IF EXISTS `reviewimg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviewimg` (
  `no` int DEFAULT NULL,
  `fileRealName` varchar(100) DEFAULT NULL,
  `imgNo` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviewimg`
--

LOCK TABLES `reviewimg` WRITE;
/*!40000 ALTER TABLE `reviewimg` DISABLE KEYS */;
INSERT INTO `reviewimg` VALUES (1,NULL,5),(1,NULL,4),(1,NULL,3),(1,NULL,2),(1,NULL,1),(2,NULL,5),(2,NULL,4),(2,NULL,3),(2,NULL,2),(2,'리뷰.jfif',1),(3,NULL,5),(3,NULL,4),(3,NULL,3),(3,NULL,2),(3,'방문자123.jfif',1),(4,NULL,5),(4,NULL,4),(4,NULL,3),(4,'방문자12323.jfif',2),(4,NULL,1),(5,NULL,5),(5,'fasdfawfe.jfif',4),(5,'rzxv.jfif',3),(5,'zxfdew.jfif',2),(5,'zxffse.jfif',1);
/*!40000 ALTER TABLE `reviewimg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userID` varchar(20) NOT NULL,
  `userPassword` varchar(20) DEFAULT NULL,
  `userName` varchar(20) DEFAULT NULL,
  `userGender` varchar(20) DEFAULT NULL,
  `userEmail` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('dmdkdk','asdf','김희선','여자','test@naver.com'),('duddn','asdf','김연욱','남자','cc@cc'),('guest','123123','게스트','남자','guest@naver.com'),('root','dusdnr511','관리자','남자','root@root'),('shali','shali','이상희','남자','guest@naver.com'),('suyoung','susu','이수영','여자','test@naver.com'),('tt','tt','tt','남자','tt@tt');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-15  9:59:16
