package rzwinkels.kletskatapi.dao;

import org.springframework.stereotype.Component;

@Component
public class TodoItemDAO {
    private final TodoItemRepository todoItemRepository;

    public TodoItemDAO(TodoItemRepository todoItemRepository) {
        this.todoItemRepository = todoItemRepository;
    }
}
