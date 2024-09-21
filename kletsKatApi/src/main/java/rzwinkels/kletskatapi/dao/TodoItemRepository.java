package rzwinkels.kletskatapi.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import rzwinkels.kletskatapi.model.CustomUser;
import rzwinkels.kletskatapi.model.TodoItem;

@Repository
public interface TodoItemRepository extends JpaRepository<TodoItem, Long> {
    TodoItem getTodoItemsByUser(CustomUser user);
}
