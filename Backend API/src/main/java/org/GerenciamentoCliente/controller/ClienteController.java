package org.GerenciamentoCliente.controller;

import org.GerenciamentoCliente.constant.Constant;
import org.GerenciamentoCliente.model.Cliente;
import org.GerenciamentoCliente.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin(origins = "http://localhost:63960", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT,
        RequestMethod.DELETE})
public class ClienteController {

    @Autowired
    private ClienteService clienteService;

    @PostMapping(Constant.API_CLIENTES)
    public ResponseEntity<Cliente> createCliente(@RequestBody Cliente cliente){

        Cliente savedCliente = clienteService.save(cliente);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedCliente);
    }

    @PutMapping(Constant.API_CLIENTES)
    public ResponseEntity<Cliente> updateCliente(@RequestBody Cliente cliente){
        Cliente updateCliente = clienteService.save(cliente);
        return ResponseEntity.ok(updateCliente);
    }

    @DeleteMapping(Constant.API_CLIENTES + "/{id}")
    public ResponseEntity<Cliente> deleteById (@PathVariable("id") String id){
        clienteService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping(Constant.API_CLIENTES)
    public ResponseEntity<List<Cliente>> findAll(){
        return ResponseEntity.ok(clienteService.findAll());
    }

    @GetMapping(Constant.API_CLIENTES + "{id}")
    public ResponseEntity<Optional<Cliente>> findById(@PathVariable("id") String id){
        return ResponseEntity.ok(clienteService.findById(id));
    }
}
