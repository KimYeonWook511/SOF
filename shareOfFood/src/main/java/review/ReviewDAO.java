package review;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;

//�����ͺ��̽��� 1:1 ����
public class ReviewDAO { // Database Access Object ������ ���� ��ü
	Connection conn;
	int no;

	public ReviewDAO() // MySQL �����ϴ� �κ�
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
			this.conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}

	public String getDate() 
	{
		//������ �ð��� �������� mysql ����
		String SQL = "select now()";
		
		try 
		{
			// pstmt ���� ��ü / conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery(); // ������ ������������ ���
			
			if (rs.next())
			{
				return rs.getString(1);				
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		
		return "Database Error";
	}

	public int getNext() 
	{
		// ���������� �ؼ� ���� �������� ���� �� ��ȣ�� ������ ��
		String SQL = "select no from review order by no desc";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			ResultSet rs = pstmt.executeQuery(); // ������ ������������ ���
			
			if (rs.next())
			{
				return rs.getInt(1) + 1; // �������� �� �� �� �Խñ� ��ȣ ������ �� + 1				
			}
			
			return 1; // �Խù��� ���� ���(ù �Խù�)
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // �����ͺ��̽� ����
		}
	}

	public int reviewWrite(int restNo, String title, String content, String writer) 
	{
		String SQL = "insert into review values (?, ?, ?, ?, ?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			pstmt.setInt(1, this.no = getNext()); // getNext() �Լ� ȣ�� (�Խñ� ��ȣ)
			pstmt.setInt(2, restNo);
			pstmt.setString(3, title); // �Ķ����(�Ű�����) title
			pstmt.setString(4, content); // �Ķ����(�Ű�����) content
			pstmt.setString(5, writer); // �Ķ����(�Ű�����) writer
			pstmt.setString(6, getDate()); // getDate() �Լ� ȣ�� (��¥)
			
			return pstmt.executeUpdate(); // ���������� insert, update, delete �� 0�̻��� ����� ��ȯ��
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //�����ͺ��̽� ����
		}
	}

	public int reviewWriteImg(int no, String fileRealName, int imgNo) 
	{
		String SQL = "insert into reviewimg values (?, ?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			pstmt.setString(2, fileRealName);
			pstmt.setInt(3, imgNo);
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //�����ͺ��̽� ����
		}
	}

	public ArrayList<Review> getReviewList(int restNo) 
	{
		String SQL = "select * from review where restNo = ? order by no desc";
		ArrayList<Review> list = new ArrayList<Review>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, restNo);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				Review review = new Review();
				review.setNo(rs.getInt("no"));
				review.setRestNo(rs.getInt("restNo"));
				review.setTitle(rs.getString("title"));
				review.setContent(rs.getString("content"));
				review.setWriter(rs.getString("writer"));
				review.setWriteDate(rs.getString("writeDate"));
				list.add(review);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}

	public Review getReview(int no) 
	{
		String SQL = "select * from review where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) 
			{
				Review review = new Review();
				review.setNo(rs.getInt("no"));
				review.setRestNo(rs.getInt("restNo"));
				review.setTitle(rs.getString("title"));
				review.setContent(rs.getString("content"));
				review.setWriter(rs.getString("writer"));
				review.setWriteDate(rs.getString("writeDate"));
				
				return review;
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return null; // �ش� ��ȣ�� ���䰡 �������� ���� ��
	}

	public ArrayList<String> getReviewImg(int no) 
	{
		String SQL = "select * from reviewimg where no = ?";
		ArrayList<String> reviewImgList = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				reviewImgList.add(rs.getString(2));
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		Collections.reverse(reviewImgList); // ����Ʈ ���� ������
		return reviewImgList;
	}

	public int reviewUpdate(int no, String title, String content) 
	{
		String SQL = "update review set title = ?, content = ? where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setInt(3, no);
			
			return pstmt.executeUpdate();
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int reviewImgUpdate(int no, String fileRealName, int imgNo) 
	{
		String SQL = "update reviewimg set fileRealName = ? where no = ? and imgNo = ?";
		
		try
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, fileRealName);
			pstmt.setInt(2, no);
			pstmt.setInt(3, imgNo);

			return pstmt.executeUpdate();
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return -1;
		}
	}

	public void serverImgFileRemove(String preFileRealName, String reviewImgPath)
	{
		if (preFileRealName == null)
		{
			return;
		}
		
		File file = new File(reviewImgPath + preFileRealName);
		file.delete();
	}

	public int delete(int no) 
	{
		String SQL = "delete from review where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int deleteImg(int no) 
	{
		String SQL = "delete from reviewimg where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			
			return pstmt.executeUpdate();
		} 
		catch (Exception e)
		{
			e.printStackTrace();
			return -1;
		}
	}
	
	public int getNo() 
	{
		return this.no;
	}
}
