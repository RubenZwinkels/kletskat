package rzwinkels.kletskatapi.dto;

import java.time.LocalDate;

public class TodoItemDTO {
    public String title;
    public String description;
    public boolean checked;
    public LocalDate creationDate;

    public TodoItemDTO(String title, String description, boolean checked, LocalDate creationDate) {
        this.title = title;
        this.description = description;
        this.checked = checked;
        this.creationDate = creationDate;
    }
}
