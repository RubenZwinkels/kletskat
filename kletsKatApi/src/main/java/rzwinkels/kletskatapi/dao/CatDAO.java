package rzwinkels.kletskatapi.dao;

import org.springframework.stereotype.Component;
import rzwinkels.kletskatapi.dto.CatDTO;
import rzwinkels.kletskatapi.model.Cat;
import rzwinkels.kletskatapi.model.CustomUser;

@Component
public class CatDAO {
    private final CatRepository catRepository;

    public CatDAO(CatRepository catRepository) {this.catRepository = catRepository;}

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
}
