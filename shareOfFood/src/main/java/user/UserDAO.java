package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//데이터베이스와 1:1 연동
public class UserDAO { //Database Access Object 데이터베이스 접근 객체
	Connection conn;
	
	public UserDAO() // MySQL 접속하는 부분
	{	
		try
		{
			String driver = "com.mysql.jdbc.Driver";
			String dbURL = "jdbc:mysql://localhost:3306/board"; // board라는 데이터 베이스
			String dbID = "root";
			String dbPassword = "root";
			
			// 1. 드라이버 확인
			Class.forName(driver);
			// 2. 연결
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public int login(String userID, String userPassword) // 로그인 시도
	{
		// 실제로 데이터베이스에 입력할 명령문
		String SQL = "select userPassword from user where userID = ?";	
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID); // 준비된 SQL문장의 첫번째 ?에 userID를 넣음
			ResultSet rs = pstmt.executeQuery(); // 완성된 SQL문장을 실행한 결과를 ResultSet에 넣음	
			if (rs.next()) // 결과가 존재하는지
			{
				if (rs.getString(1).equals(userPassword))
				{
					return 1; // 아이디가 존재하고 비밀번호 일치 (로그인 성공)
				}
				else
				{
					return 0; // 아이디는 존재하나 비밀번호 불일치 (로그인 실패)
				}
			}
			return -1; // 결과가 존재하지 않음(아이디가 존재하지 않음)
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return -2; // 데이터베이스 오류
	}
	
	public int join(User user) // 회원가입
	{
		String SQL = "insert into user values (?, ?, ?, ?, ?)";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			
			return pstmt.executeUpdate(); // 성공적으로 insert, update, delete 시 0이상의 결과를 반환함
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return -1; // 데이터베이스 오류
	}
}
