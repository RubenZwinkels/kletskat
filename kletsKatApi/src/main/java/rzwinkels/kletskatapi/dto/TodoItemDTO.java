package rzwinkels.kletskatapi.dto;

import java.time.LocalDate;
import java.util.UUID;

public class TodoItemDTO {
    public UUID id;
    public String title;
    public String description;
    public boolean checked;
    public LocalDate creationDate;

    public TodoItemDTO(UUID id, String title, String description, boolean checked, LocalDate creationDate) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.checked = checked;
        this.creationDate = creationDate;
    }
}
