package edu.iacademy.cselec05.pm_rima.servlet;

import edu.iacademy.cselec05.pm_rima.dao.UserDAO;
import edu.iacademy.cselec05.pm_rima.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EditUserServlet extends HttpServlet {

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(idParam);
            User user = UserDAO.getInstance().findById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
            request.setAttribute("editUser", user);
            request.getRequestDispatcher("/edit-user.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("user_id");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String status = request.getParameter("status");

        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(idParam);
            User user = UserDAO.getInstance().findById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            boolean success = UserDAO.getInstance().updateUser(userId, fullName, email, status);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?updated=true&updatedUser=" + user.getUsername());
            } else {
                request.setAttribute("editUser", user);
                request.setAttribute("errorMessage", "Update failed. Email may already be in use.");
                request.getRequestDispatcher("/edit-user.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
