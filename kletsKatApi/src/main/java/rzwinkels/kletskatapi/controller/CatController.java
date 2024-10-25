package rzwinkels.kletskatapi.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import rzwinkels.kletskatapi.dao.CatDAO;
import rzwinkels.kletskatapi.dao.UserDAO;
import rzwinkels.kletskatapi.dto.CatDTO;
import rzwinkels.kletskatapi.model.Cat;
import rzwinkels.kletskatapi.model.CustomUser;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/cat")
public class CatController {
    private final UserDAO userDAO;
    private final CatDAO catDAO;

    public CatController(UserDAO userDAO, CatDAO catDAO) {
        this.userDAO = userDAO;
        this.catDAO = catDAO;
    }

    @PostMapping
    public ResponseEntity<String> saveCat(@RequestBody CatDTO cat){
        CustomUser currentUser = null;
        cat.setBond(0);
        try {
            currentUser = userDAO.getCurrentUser();
        } catch (Error e) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );
        }
        catDAO.updateCurrentUsersCat(cat);
        return ResponseEntity.ok("Kat opgeslagen");
    }

    @GetMapping
    public ResponseEntity<CatDTO> getCatByUser(){
        CustomUser currentuser = null;
        try {
            currentuser = userDAO.getCurrentUser();
        } catch (Error e){
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "User not found"
            );
        }
        Cat usersCat = catDAO.fetchUsersCat(currentuser);
        CatDTO usersCatDTO = catDAO.convertCatToDTO(usersCat);
        return ResponseEntity.ok(usersCatDTO);
    }
}
