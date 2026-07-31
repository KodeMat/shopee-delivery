package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/VehicleServlet")
public class VehicleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Connect the MySQL database
    private static final String URL = "";
    private static final String USER = "";
    private static final String PASSWORD = "";

    // ==========================
    // ADD / UPDATE
    // ==========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        String plateNumber = request.getParameter("plateNumber");
        String vehicleType = request.getParameter("vehicleType");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String status = request.getParameter("status");

        int capacity = 0;

        try {
            capacity = Integer.parseInt(request.getParameter("capacity"));
        } catch (Exception e) {
            capacity = 0;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(URL, USER, PASSWORD);

            // ==========================
            // ADD VEHICLE
            // ==========================
            if ("add".equals(action)) {

                String sql = "INSERT INTO vehicles "
                        + "(plate_number, vehicle_type, brand, model, capacity, status) "
                        + "VALUES (?,?,?,?,?,?)";

                ps = con.prepareStatement(sql);

                ps.setString(1, plateNumber);
                ps.setString(2, vehicleType);
                ps.setString(3, brand);
                ps.setString(4, model);
                ps.setInt(5, capacity);
                ps.setString(6, status);

                ps.executeUpdate();

            }

            // ==========================
            // UPDATE VEHICLE
            // ==========================
            else if ("edit".equals(action)) {

                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));

                String sql = "UPDATE vehicles SET "
                        + "plate_number=?, "
                        + "vehicle_type=?, "
                        + "brand=?, "
                        + "model=?, "
                        + "capacity=?, "
                        + "status=? "
                        + "WHERE vehicle_id=?";

                ps = con.prepareStatement(sql);

                ps.setString(1, plateNumber);
                ps.setString(2, vehicleType);
                ps.setString(3, brand);
                ps.setString(4, model);
                ps.setInt(5, capacity);
                ps.setString(6, status);
                ps.setInt(7, vehicleId);

                ps.executeUpdate();
            }

            response.sendRedirect("vehicle.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("vehicle.jsp?error=true");

        } finally {

            try {
                if (ps != null)
                    ps.close();
            } catch (Exception e) {
            }

            try {
                if (con != null)
                    con.close();
            } catch (Exception e) {
            }

        }

    }

    // ==========================
    // DELETE VEHICLE
    // ==========================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {

            Connection con = null;
            PreparedStatement ps = null;

            try {

                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));

                Class.forName("com.mysql.cj.jdbc.Driver");

                con = DriverManager.getConnection(URL, USER, PASSWORD);

                String sql = "DELETE FROM vehicles WHERE vehicle_id=?";

                ps = con.prepareStatement(sql);

                ps.setInt(1, vehicleId);

                ps.executeUpdate();

            } catch (Exception e) {

                e.printStackTrace();

            } finally {

                try {
                    if (ps != null)
                        ps.close();
                } catch (Exception e) {
                }

                try {
                    if (con != null)
                        con.close();
                } catch (Exception e) {
                }

            }

        }

        response.sendRedirect("vehicle.jsp");

    }

}