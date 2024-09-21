package rzwinkels.kletskatapi.dao;

import rzwinkels.kletskatapi.model.CustomUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<CustomUser, Long> {
    CustomUser findByEmail(String email);
    CustomUser findById(UUID uuid);
}
