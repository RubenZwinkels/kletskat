package rzwinkels.kletskatapi.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import rzwinkels.kletskatapi.model.CustomUser;
import rzwinkels.kletskatapi.model.TodoItem;

import java.util.List;
import java.util.UUID;

@Repository
public interface TodoItemRepository extends JpaRepository<TodoItem, Long> {
    List<TodoItem> getTodoItemsByUser(CustomUser user);
    TodoItem findById(UUID uuid);
}
