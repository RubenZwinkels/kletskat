package rzwinkels.kletskatapi.model;

import jakarta.persistence.Entity;
import java.time.LocalDate;
import java.util.Date;
import java.util.UUID;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;


@Entity(name = "TodoItem")
public class TodoItem {
    @Id
    @GeneratedValue
    private UUID id;
    private String title;
    private String description;
    private boolean checked = false;
    private LocalDate creationDate = LocalDate.now();
    @ManyToOne
    private CustomUser user;

    public TodoItem(UUID id, String title, String description, boolean checked, LocalDate creationDate, CustomUser user) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.checked = checked;
        this.creationDate = creationDate;
        this.user = user;
    }
    public TodoItem(){}

    public UUID getId() {
        return id;
    }

    public CustomUser getUser() {
        return user;
    }
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public LocalDate getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDate creationDate) {
        this.creationDate = creationDate;
    }

    public void setUser(CustomUser user) {
        this.user = user;
    }
}
