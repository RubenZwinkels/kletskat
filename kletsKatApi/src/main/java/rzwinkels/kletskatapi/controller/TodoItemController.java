package rzwinkels.kletskatapi.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import rzwinkels.kletskatapi.dao.TodoItemDAO;
import rzwinkels.kletskatapi.dto.TodoItemDTO;
import rzwinkels.kletskatapi.model.TodoItem;

import java.util.List;
import java.util.UUID;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/todo")
public class TodoItemController {
    private final TodoItemDAO todoItemDAO;

    public TodoItemController(TodoItemDAO todoItemDAO){
        this.todoItemDAO = todoItemDAO;
    }

    @GetMapping
    public ResponseEntity<List<TodoItemDTO>> getUserTodoItems() {
        List<TodoItemDTO> todoItems = this.todoItemDAO.getTodoItemCurrentUser();
        return ResponseEntity.ok(todoItems);
    }

    @PostMapping
    public ResponseEntity<String> postTodoItem(@RequestBody TodoItemDTO todoItemDTO) {
        this.todoItemDAO.saveTodoItem(todoItemDTO);

        return ResponseEntity.ok("todoItem opgeslagen");
    }

    @PutMapping
    public ResponseEntity<String> toggleTodoItem(@RequestBody UUID id) {
        todoItemDAO.toggleTodoItem(id);
        return ResponseEntity.ok("todoItem getoggeld");
    }
}
