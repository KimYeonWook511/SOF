package board;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;

//�����ͺ��̽��� 1:1 ����
public class BoardDAO { // Database Access Object ������ ���� ��ü
	Connection conn;
	int no;

	public BoardDAO() // MySQL �����ϴ� �κ�
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
		String SQL = "select no from board order by no desc";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			ResultSet rs = pstmt.executeQuery(); // ������ ������������ ���
			
			if (rs.next())
			{
				return rs.getInt("no") + 1; // �������� �� �� �� �Խñ� ��ȣ ������ �� + 1				
			}
			
			return 1; // �Խù��� ���� ���(ù �Խù�)
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // �����ͺ��̽� ����
		}
	}

	public int boardWrite(String title, String addr, String type, String price, String content, String writer) 
	{
		String SQL = "insert into board values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			pstmt.setInt(1, this.no = getNext()); // getNext() �Լ� ȣ�� (�Խñ� ��ȣ)
			pstmt.setString(2, title); // �Ķ����(�Ű�����) title
			pstmt.setString(3, addr); // �Ķ����(�Ű�����) addr
			pstmt.setString(4, type); // �Ķ����(�Ű�����) type
			pstmt.setString(5, price); // �Ķ����(�Ű�����) price
			pstmt.setString(6, content); // �Ķ����(�Ű�����) content
			pstmt.setString(7, writer); // �Ķ����(�Ű�����) writer
			pstmt.setString(8, getDate()); // getDate() �Լ� ȣ�� (��¥)
			pstmt.setInt(9, 0); // ��ȸ��
			
			return pstmt.executeUpdate(); // ���������� insert, update, delete �� 0�̻��� ����� ��ȯ��
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //�����ͺ��̽� ����
		}
	}

	public int boardWriteImg(int no, String fileRealName, int imgNo) 
	{
		String SQL = "insert into boardimg values (?, ?, ?)";
		
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

	public ArrayList<Board> getList(int pageNumber) 
	{
		String SQL = "select * from board where no < ? order by no desc limit 15"; // limit 15�� ������ 15���� ������ �� �ְ� ��
		ArrayList<Board> list = new ArrayList<>();
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 15); /*
																 * getNext() = ���� ���� ��ȣ 
																 * ���� �Խñ��� 13���̰� 1�������� no < 14 �ؼ� 13���� ��ϸ� ������
																 * ���� �Խñ��� 24���̰� 2�������� no < (25 - 15) �ؼ� 9���� ��ϸ� ������ 
																 */
			ResultSet rs = pstmt.executeQuery(); // ������ ���
			
			while (rs.next()) 
			{
				Board board = new Board();
				board.setNo(rs.getInt("no"));
				board.setTitle(rs.getString("title"));
				board.setAddr(rs.getString("addr"));
				board.setType(rs.getString("type"));
				board.setPrice(rs.getString("price"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setWriteDate(rs.getString("writeDate"));
				board.setViewCount(rs.getInt("viewCount"));
				list.add(board);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<Board> getSearchList(int pageNumber,String selected, String search)
	{
		String concat = "concat��";
		
		if (selected.equals("��ü"))
		{
			concat = " concat(title, addr, type, content, writer) ";
		}
		else if (selected.equals("����"))
		{
			concat = " concat(title) ";
		}
		else if (selected.equals("�ּ�"))
		{
			concat = " concat(addr) ";
		}
		else if (selected.equals("�з�"))
		{
			concat = " concat(type) ";
		}
		else if (selected.equals("�Ұ�����"))
		{
			concat = " concat(content) ";
		}
		else if (selected.equals("�ۼ���"))
		{
			concat = " concat(writer) ";
		}
		else
		{
			return null;
		}
		
		String SQL = "select * from board where" + concat + "like ? order by no desc";
		ArrayList<Board> list = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			ResultSet rs = pstmt.executeQuery();
			int rsCnt = 0; // ������ ��� ī��Ʈ ��
			
			while (rs.next())
			{
				rsCnt++;
				
				if (pageNumber * 15 >= rsCnt && (pageNumber - 1) * 15 < rsCnt)
				{
					Board board = new Board();
					board.setNo(rs.getInt("no"));
					board.setTitle(rs.getString("title"));
					board.setAddr(rs.getString("addr"));
					board.setType(rs.getString("type"));
					board.setPrice(rs.getString("price"));
					board.setContent(rs.getString("content"));
					board.setWriter(rs.getString("writer"));
					board.setWriteDate(rs.getString("writeDate"));
					board.setViewCount(rs.getInt("viewCount"));
					list.add(board);					  
				}
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public int getSearchTotal(String selected, String search)
	{
		// �˻��� �Խñ��� �� ����
		String concat = "concat��";
		
		if (selected.equals("��ü"))
		{
			concat = " concat(title, addr, type, content, writer) ";
		}
		else if (selected.equals("����"))
		{
			concat = " concat(title) ";
		}
		else if (selected.equals("�ּ�"))
		{
			concat = " concat(addr) ";
		}
		else if (selected.equals("�з�"))
		{
			concat = " concat(type) ";
		}
		else if (selected.equals("�Ұ�����"))
		{
			concat = " concat(content) ";
		}
		else if (selected.equals("�ۼ���"))
		{
			concat = " concat(writer) ";
		}
		else
		{
			return -1;
		}
		
		String SQL = "select * from board where" + concat + "like ?";
		
		try
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			ResultSet rs = pstmt.executeQuery();
			int total = 0;
			
			while (rs.next())
			{
				total++;		
			}
			
			return total;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -2; // �����ͺ��̽� ����
		}		
	}
	
	public boolean lastSearchPage(int pageNumber, String selected, String search)
	{
		String concat = "concat��";
		
		if (selected.equals("��ü"))
		{
			concat = " concat(title, addr, type, content, writer) ";
		}
		else if (selected.equals("����"))
		{
			concat = " concat(title) ";
		}
		else if (selected.equals("�ּ�"))
		{
			concat = " concat(addr) ";
		}
		else if (selected.equals("�з�"))
		{
			concat = " concat(type) ";
		}
		else if (selected.equals("�Ұ�����"))
		{
			concat = " concat(content) ";
		}
		else if (selected.equals("�ۼ���"))
		{
			concat = " concat(writer) ";
		}
		
		String SQL = "select * from board where" + concat + "like ? order by no desc";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			ResultSet rs = pstmt.executeQuery();
			int rsCnt = 0; // ������ ��� ī��Ʈ ��
			
			while (rs.next())
			{
				rsCnt++;
			}
			
			if (pageNumber * 15 < rsCnt)
			{
				return false; // �˻����� ������ ������ �ƴ�
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return true; // �˻����� ������ ��������
	}
	
	public boolean lastPage(int pageNumber) // ������ ������ Ȯ�� �޼ҵ�
	{
		String SQL = "select * from board where no < ? order by no desc limit 15";
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			pstmt.setInt(1, getNext() - pageNumber * 15);
			ResultSet rs = pstmt.executeQuery(); // ������ ���
			
			if (rs.next())
			{
				return false; // ������ �������� �ƴ� // ������ �������� �ƴ�
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return true; // ������ ��������
	}

	public Board getBoard(int no) 
	{
		String SQL = "select * from board where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) 
			{
				Board board = new Board();
				board.setNo(rs.getInt("no"));
				board.setTitle(rs.getString("title"));
				board.setAddr(rs.getString("addr"));
				board.setType(rs.getString("type"));
				board.setPrice(rs.getString("price"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setWriteDate(rs.getString("writeDate"));
				board.setViewCount(rs.getInt("viewCount"));
				
				return board;
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return null; // �ش� ��ȣ�� ���� �������� ���� ��
	}

	public ArrayList<String> getBoardImg(int no) 
	{
		String SQL = "select * from boardimg where no = ?";
		ArrayList<String> boardImgList = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				boardImgList.add(rs.getString(2));
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		Collections.reverse(boardImgList); // ����Ʈ ���� ������
		return boardImgList;
	}

	public int upViewCount(int no, int viewCount)
	{
		String SQL = "update board set viewCount = ? where no = ?";
		
		try 
		{			
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, viewCount + 1);
			pstmt.setInt(2, no);
			
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}
	
	public int boardUpdate(int no, String title, String addr, String type, String price, String content) 
	{
		String SQL = "update board set title = ?, addr = ?, type = ?, price = ?, content = ? where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, title);
			pstmt.setString(2, addr);
			pstmt.setString(3, type);
			pstmt.setString(4, price);
			pstmt.setString(5, content);
			pstmt.setInt(6, no);
			
			return pstmt.executeUpdate();
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int boardImgUpdate(int no, String fileRealName, int imgNo) 
	{
		String SQL = "update boardimg set fileRealName = ? where no = ? and imgNo = ?";
		
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

	public void serverImgFileRemove(String preFileRealName, String boardImgPath)
	{
		if (preFileRealName == null)
		{
			return;
		}
		
		File file = new File(boardImgPath + preFileRealName);
		file.delete();
	}

	public int delete(int no) 
	{
		String SQL = "delete from board where no = ?";
		
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
		String SQL = "delete from boardimg where no = ?";
		
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

	public int refreshNo(int no) // �Խñ� ���� �� �Խñ� ��ȣ ���ΰ�ħ
	{
		String SQL = "update board set no = ? where no = ?";
		
		if (no == getNext() + 1) return 0; // ������ �Խñ��� ������ ��ȣ���� �� ������
		
		try 
		{
			for (int i = 0; i < getNext() - no; i++) 
			{
				PreparedStatement pstmt = this.conn.prepareStatement(SQL);
				pstmt.setInt(1, no + i);
				pstmt.setInt(2, no + i + 1);
				pstmt.executeUpdate();
			}
			return 1;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int refreshImgNo(int no) 
	{
		String SQL = "update boardimg set no = ? where no = ?";
		
		if (no == getNext() + 1) return 0; // ������ �Խñ��� ������ ��ȣ���� �� ������
		try 
		{
			for (int i = 0; i < getNext() - no; i++) 
			{
				PreparedStatement pstmt = this.conn.prepareStatement(SQL);
				pstmt.setInt(1, no + i);
				pstmt.setInt(2, no + i + 1);
				pstmt.executeUpdate();
			}
			return 1;
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
	
	public ArrayList<Board> getHotBoardList()
	{
		String SQL = "select * from board order by viewCount desc limit 6"; // 6���� �Խñ۸� ��������
		ArrayList<Board> hotList = new ArrayList<Board>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				Board board = new Board();
				board.setNo(rs.getInt("no"));
				board.setTitle(rs.getString("title"));
				board.setAddr(rs.getString("addr"));
				board.setType(rs.getString("type"));
				board.setPrice(rs.getString("price"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setWriteDate(rs.getString("writeDate"));
				board.setViewCount(rs.getInt("viewCount"));
				hotList.add(board);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return hotList;
	}
}
