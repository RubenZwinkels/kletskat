package rzwinkels.kletskatapi.dao;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import rzwinkels.kletskatapi.dto.TodoItemDTO;
import rzwinkels.kletskatapi.model.CustomUser;
import rzwinkels.kletskatapi.model.TodoItem;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
public class TodoItemDAO {
    private final TodoItemRepository todoItemRepository;
    private final UserDAO userDAO;

    public TodoItemDAO(TodoItemRepository todoItemRepository, UserDAO userDAO) {
        this.todoItemRepository = todoItemRepository;
        this.userDAO = userDAO;
    }

    public List<TodoItemDTO> getTodoItemCurrentUser() {
        CustomUser user = this.userDAO.getCurrentUser();
        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );
        }
        List<TodoItem> todoItems = this.todoItemRepository.getTodoItemsByUser(user);
        return toDTOList(todoItems);
    }

    public void saveTodoItem(TodoItemDTO todoItemDTO) {
        CustomUser user = this.userDAO.getCurrentUser();
        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );
        }

        // maak een nieuw TodoItem object
        TodoItem todoItem = new TodoItem();
        todoItem.setTitle(todoItemDTO.title);
        todoItem.setDescription(todoItemDTO.description);
        todoItem.setChecked(todoItemDTO.checked);
        todoItem.setCreationDate(todoItemDTO.creationDate);
        todoItem.setUser(user);

        // opslaan
        TodoItem savedTodoItem = this.todoItemRepository.save(todoItem);
    }

    public static TodoItemDTO toDTO(TodoItem todoItem) {
        return new TodoItemDTO(
                todoItem.getTitle(),
                todoItem.getDescription(),
                todoItem.isChecked(),
                todoItem.getCreationDate()
        );
    }

    public static List<TodoItemDTO> toDTOList(List<TodoItem> todoItems) {
        return todoItems.stream()
                .map(TodoItemDAO::toDTO)
                .collect(Collectors.toList());
    }
}