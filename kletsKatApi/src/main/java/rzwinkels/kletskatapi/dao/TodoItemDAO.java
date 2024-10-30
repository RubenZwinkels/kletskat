package rzwinkels.kletskatapi.dao;

import jakarta.transaction.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import rzwinkels.kletskatapi.dto.TodoItemDTO;
import rzwinkels.kletskatapi.model.CustomUser;
import rzwinkels.kletskatapi.model.TodoItem;

import java.beans.Transient;
import java.time.LocalDate;
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
        todoItem.setCreationDate(LocalDate.now());
        todoItem.setUser(user);

        // opslaan
        TodoItem savedTodoItem = this.todoItemRepository.save(todoItem);
    }

    public static TodoItemDTO toDTO(TodoItem todoItem) {
        return new TodoItemDTO(
                todoItem.getId(),
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

    public void toggleTodoItem(UUID id) {
        TodoItem todoItem = todoItemRepository.findById(id);
        todoItem.setChecked(!todoItem.isChecked());

        //opslaan
        TodoItem updatedTodoItem = todoItemRepository.save(todoItem);
    }

    @Transactional
    public void deleteTodoItem(UUID id) {
        UUID currentUserId = this.userDAO.getCurrentUser().getId();
        UUID todoItemUserId = this.todoItemRepository.findById(id).getUser().getId();
        if (currentUserId != todoItemUserId){
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED, "Current user is not the owner of the todo item"
            );
        }
        this.todoItemRepository.deleteById(id);
    }
}