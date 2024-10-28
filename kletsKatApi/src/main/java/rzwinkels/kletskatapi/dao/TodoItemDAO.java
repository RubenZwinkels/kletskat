package rzwinkels.kletskatapi.dao;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import rzwinkels.kletskatapi.model.CustomUser;
import rzwinkels.kletskatapi.model.TodoItem;

import java.util.List;

@Component
public class TodoItemDAO {
    private final TodoItemRepository todoItemRepository;
    private final UserDAO userDAO;

    public TodoItemDAO(TodoItemRepository todoItemRepository, UserDAO userDAO) {
        this.todoItemRepository = todoItemRepository;
        this.userDAO = userDAO;
    }

    public List<TodoItem> getTodoItemCurrentUser(){
        CustomUser user = this.userDAO.getCurrentUser();
        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );
        }
        List<TodoItem> todoItems = this.todoItemRepository.getTodoItemsByUser(user);

        return todoItems;
    }
}
