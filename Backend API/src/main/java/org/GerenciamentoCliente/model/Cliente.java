package org.GerenciamentoCliente.model;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@Getter @Setter
public class Cliente {

    @Id
    private String id;
    private String nome;
    private String email;
    private String telefone;
    private String cep;
    private String localidade;
    private String estado;
    private String uf;


}
