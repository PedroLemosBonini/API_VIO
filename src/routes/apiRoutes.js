const router = require("express").Router();
const userController = require("../controller/userController");
const verifyJWT = require("../services/verifyJWT")

router.post("/user/", userController.createUser);
router.get("/user/",verifyJWT, userController.getAllUsers);
router.put("/user/", userController.updateUser);
router.delete("/user/:id", userController.deleteUser);
router.post("/login/", userController.loginUser);

const orgController = require("../controller/orgController");

router.post('/organizador', orgController.createOrg);
router.get('/organizador', orgController.getAllOrg);
router.put('/organizador', orgController.updateOrg);
router.delete('/organizador/:id', orgController.deleteOrg);


// Rotas evento controller
const eventoController = require("../controller/eventoController");

router.post("/evento/", eventoController.createEvento);
router.get("/evento/",verifyJWT, eventoController.getAllEventos);
router.put("/evento/", eventoController.updateEvento);
router.delete("/evento/:id", eventoController.deleteEvento);
router.get("/evento/data",verifyJWT, eventoController.getEventosForData);
router.get("/evento/:data",verifyJWT, eventoController.getEventosDias);

const ingressoController = require("../controller/ingressoController");

router.post("/ingresso/", ingressoController.createIngresso);
router.get("/ingresso/", ingressoController.getAllIngressos);
router.put("/ingresso/", ingressoController.updateIngresso);
router.delete("/ingresso/:id", ingressoController.deleteIngresso);
router.get("/ingresso/evento/:id", ingressoController.getByIdEvento);

module.exports = router;
