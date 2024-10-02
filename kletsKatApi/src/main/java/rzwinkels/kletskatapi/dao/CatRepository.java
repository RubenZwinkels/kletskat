package rzwinkels.kletskatapi.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import rzwinkels.kletskatapi.model.Cat;
import rzwinkels.kletskatapi.model.CustomUser;

import java.util.UUID;

public interface CatRepository extends JpaRepository<Cat, UUID> {
    public Cat getCatByUser(CustomUser user);
}
