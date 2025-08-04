const connect = require("../db/connect");

module.exports = class compraController {
  static async registrarCompraSimples(req, res) {
    const { id_usuario, id_ingresso, quantidade } = req.body;

    console.log("Body: ", id_usuario, id_ingresso, quantidade);

    if (!id_usuario || !id_ingresso || !quantidade) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos" });
    }

    connect.query(
      "call registrar_compra(?,?,?);",
      [id_usuario, id_ingresso, quantidade],
      (err, result) => {
        if (err) {
          console.log("Erro ao registrar compra: ", err.message);
          return res.status(500).json({ error: err.message });
        }

        return res.status(201).json({
          message: "Compra registrada com sucesso via procedure!",
          dados: {
            id_usuario,
            id_ingresso,
            quantidade,
          },
        });
      }
    );
  }

  static async registrarCompra(req, res) {
    const { id_usuario, ingressos } = req.body;

    console.log("Body: ", id_usuario, ingressos);

    connect.query(
      "insert into compra(data_compra, fk_id_usuario) values(now(), ?)",
      [id_usuario],
      (err, result) => {
        if (err) {
          console.log("Erro ao inserir compra: ", err.message);
          return res
            .status(500)
            .json({ error: "Erro ao criar compra no sistema" });
        }

        // Recupera o id da compra recém criada
        const id_compra = result.insertId;
        console.log("Compra criada com o ID: ", id_compra);

        // Inicializa o índice dos ingressos a serem processados
        let index = 0;

        // Função recursiva para processar cada ingresso sequencialmente
        function processarIngressos() {
          // Condição: todos os ingressos foram processados?
          if (index >= ingressos.length) {
            return res.status(201).json({
              message: "Compra realizada com sucesso!",
              id_compra,
              ingressos,
            });
          }

          // Obter o ingresso atual com base no indice
          const ingresso = ingressos[index];

          // Chamada da procedure para registrar as compras
          connect.query(
            "call registrar_compra2(?,?,?)",
            [ingresso.id_ingresso, id_compra, ingresso.quantidade],
            (err) => {
              if (err) {
                return res.status(500).json({
                  error: `Erro ao registrar ingresso ${index + 1}`,
                  detalhes: err.message,
                });
              }

              index++;
              processarIngressos();
            }
          );
        }
        processarIngressos();
      }
    );
  }
};