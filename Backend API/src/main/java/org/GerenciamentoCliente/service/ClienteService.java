package org.GerenciamentoCliente.service;

import org.GerenciamentoCliente.model.Cliente;
import org.GerenciamentoCliente.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    public Cliente save(Cliente cliente){
        clienteRepository.save(cliente);
        return cliente;
    }

    public List<Cliente> findAll(){
        return clienteRepository.findAll();
    }

    public Optional<Cliente> findById(String id){
        return clienteRepository.findById(id);
    }

    public void deleteById(String id){
        clienteRepository.deleteById(id);
    }
}
