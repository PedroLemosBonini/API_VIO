const connect = require("../db/connect");

module.exports = class eventoController {
  // Criação de um evento
  static async createEvento(req, res) {
    const { nome, descricao, data_hora, local, fk_id_organizador } = req.body;

    // Validação genérica de todos
    if (!nome || !descricao || !data_hora || !local || !fk_id_organizador) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos" });
    }

    const query = `insert into evento (nome, descricao, data_hora, local, fk_id_organizador) values(?, ?, ?, ?, ?)`;

    const values = [nome, descricao, data_hora, local, fk_id_organizador];

    try {
      connect.query(query, values, (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao criar o evento!" });
        }

        return res.status(201).json({ message: "Evento criado com sucesso!" });
      });
    } catch (error) {
      console.log("Erro ao executar query: ", error);
      return res.status(500).json({ error: "Erro interno do servidor!" });
    }
  }

  // Visualizar todos os eventos
  static async getAllEventos(req, res) {
    const query = `select * from evento`;

    try {
      connect.query(query, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(400).json("Erro ao obter eventos!");
        }
        return res
          .status(200)
          .json({ message: "Eventos listados com sucesso:", events: results });
      });
    } catch (error) {
      console.log("Erro ao executar a query", error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  static async updateEvento(req, res) {
    const { id_evento, nome, descricao, data_hora, local, fk_id_organizador } =
      req.body;

    // Validação genérica de todos
    if (
      !id_evento ||
      !nome ||
      !descricao ||
      !data_hora ||
      !local ||
      !fk_id_organizador
    ) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos" });
    }

    const query = `update evento set nome=?, descricao=?, data_hora=?, local=?, fk_id_organizador=? where id_evento=?`;

    const values = [
      nome,
      descricao,
      data_hora,
      local,
      fk_id_organizador,
      id_evento,
    ];

    try {
      connect.query(query, values, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao atualizar o evento!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Evento não encontrado" });
        }

        return res
          .status(200)
          .json({ message: "Evento atualizado com sucesso!" });
      });
    } catch (error) {
      console.log("Erro ao consultar consulta: ", error);
      return res.status(500).json({ error: "Erro interno do servidor!" });
    }
  }

  static async deleteEvento(req, res) {
    const eventoId = req.params.id;
    const query = `DELETE FROM evento where id_evento = ?`
    const values = [eventoId];

    try {
      connect.query(query, values, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(400).json({ error: "Erro ao deletar evento!" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Evento não encontrado!" });
        }
        return res
          .status(200)
          .json({ message: "Evento deletado com sucesso!" });
      });
    } catch {
      console.log(error);
      return res.status(500).json({ error: "Erro interno do servidor!" });
    }
  }

  static async getEventosForData(req, res){
    const query = `SELECT * FROM evento`
    try {
      connect.query(query,(err, results) => {
        if(err){
          console.error(err)
          return res.status(400).json({error:"Erro ao buscar eventos"})
        }
        const dataEvento = new Date(results[0].data_hora)
        const dia = dataEvento.getDate()
        const mes = dataEvento.getMonth()
        const ano = dataEvento.getFullYear()
        console.log(dia + '/' + mes + '/' + ano);

        const now = new Date()
        const eventosPassados = results.filter(evento => new Date(evento.data_hora)<now)
        const eventosFuturos = results.filter(evento => new Date(evento.data_hora)>=now)

        const diferencaMs = eventosFuturos[0].data_hora.getTime() - now.getTime()
        const dias = Math.floor(diferencaMs / (1000 * 60 * 60 * 24))
        const horas = Math.floor(diferencaMs % (1000*60*60*24)/(1000*60*60))
        console.log(diferencaMs, "Faltam: "+dias+" dias e "+horas+" horas")

        //Comparar datas
        const dataFiltro = new Date("2024-12-15").toISOString().split("T")
        const eventosDia = results.filter(evento => new Date(evento.data_hora).toISOString().split("T")[0] === dataFiltro[0])

        console.log("Eventos: ", eventosDia)

        return res.status(200).json({message:"OK!",eventosPassados,eventosFuturos})
      })
    } catch (error) {
      console.error(error)
      return res.status(500).json({error:"Erro interno do servidor"})
    }
    
  }

  static async getEventosDias(req, res){
    const {data} = req.params
    const query = `SELECT * FROM evento`

    const inicio = new Date(data)
    const fim = new Date(inicio)
    fim.setDate(fim.getDate() + 6)

    
    try {
      connect.query(query,(err, results) => {
        if(err){
          console.log(err)
          return res.status(400).json({error:"Erro ao obter eventos"})
        }
      
        const semanal = results.filter((evento) => {const dataEvento = new Date(evento.data_hora)
        return dataEvento >= inicio && fim <= fim
        })

        return res.status(200).json({message:"Eventos obtidos com sucesso: ", semanal})

      })
    } catch (error) {
      console.log(error)
      return res.status(500).json({error:"Erro interno do servidor"})
    }
  }
};
