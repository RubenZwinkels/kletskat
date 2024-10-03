package rzwinkels.kletskatapi.dao;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import rzwinkels.kletskatapi.dto.CatDTO;
import rzwinkels.kletskatapi.model.Cat;
import rzwinkels.kletskatapi.model.CustomUser;

import java.util.Optional;
import java.util.UUID;

@Component
public class CatDAO {
    private final CatRepository catRepository;
    private UserDAO userdao;

    public CatDAO(CatRepository catRepository, UserDAO userDAO) {this.catRepository = catRepository; this.userdao = userDAO;}

    public void saveCat(Cat cat){
        catRepository.save(cat);
    }
    public void saveCat(CatDTO cat, CustomUser user){
        Cat catModel = new Cat(user, cat.getColor(), cat.getEyeColor(), cat.getName(), cat.getBond(), cat.getPersonality());
        catRepository.save(catModel);
    }

    public Cat fetchUsersCat(CustomUser user){
        return catRepository.getCatByUser(user);
    }

    public UUID getCatIdByUser() {
        CustomUser currentUser = userdao.getCurrentUser();
        Cat cat = catRepository.getCatByUser(currentUser);
        return cat.getId();
    }

    public void updateCat(UUID catId, CatDTO updatedCatData) {
        Optional<Cat> optionalCat = catRepository.findById(catId);

        if (optionalCat.isPresent()) {
            Cat catToUpdate = optionalCat.get();
            catToUpdate.setColor(updatedCatData.getColor());
            catToUpdate.setEyeColor(updatedCatData.getEyeColor());
            catToUpdate.setName(updatedCatData.getName());
            catToUpdate.setBond(updatedCatData.getBond());
            catToUpdate.setPersonality(updatedCatData.getPersonality());

            catRepository.save(catToUpdate);
        } else {
            saveCat(updatedCatData, userdao.getCurrentUser());
        }
    }

}
