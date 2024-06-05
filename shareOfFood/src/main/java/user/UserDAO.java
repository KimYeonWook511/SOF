package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//�����ͺ��̽��� 1:1 ����
public class UserDAO { //Database Access Object �����ͺ��̽� ���� ��ü
	Connection conn;
	
	public UserDAO() // MySQL �����ϴ� �κ�
	{	
		try
		{
			String driver = "com.mysql.jdbc.Driver";
			String dbURL = "jdbc:mysql://localhost:3306/board"; // board��� ������ ���̽�
			String dbID = "root";
			String dbPassword = "root";
			
			// 1. ����̹� Ȯ��
			Class.forName(driver);
			// 2. ����
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public int login(String userID, String userPassword) // �α��� �õ�
	{
		// ������ �����ͺ��̽��� �Է��� ��ɹ�
		String SQL = "select userPassword from user where userID = ?";	
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID); // �غ�� SQL������ ù��° ?�� userID�� ����
			ResultSet rs = pstmt.executeQuery(); // �ϼ��� SQL������ ������ ����� ResultSet�� ����	
			if (rs.next()) // ����� �����ϴ���
			{
				if (rs.getString(1).equals(userPassword))
				{
					return 1; // ���̵� �����ϰ� ��й�ȣ ��ġ (�α��� ����)
				}
				else
				{
					return 0; // ���̵�� �����ϳ� ��й�ȣ ����ġ (�α��� ����)
				}
			}
			return -1; // ����� �������� ����(���̵� �������� ����)
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return -2; // �����ͺ��̽� ����
	}
	
	public int join(User user) // ȸ������
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
			
			return pstmt.executeUpdate(); // ���������� insert, update, delete �� 0�̻��� ����� ��ȯ��
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return -1; // �����ͺ��̽� ����
	}
}
