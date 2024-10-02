package rzwinkels.kletskatapi.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import rzwinkels.kletskatapi.dao.CatDAO;
import rzwinkels.kletskatapi.dao.UserDAO;

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
}
