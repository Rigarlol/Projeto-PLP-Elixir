defmodule Cep do
  def run(cep \\ "57307420") do
    cep
    |> buscar_cep()
    |> tratar_retorno()
    |> formatar_resposta()
  end

  def buscar_cep(cep) do
    HTTPoison.get("https://viacep.com.br/ws/#{cep}/json/")
  end

  def tratar_retorno({:ok, %{body: body, status_code: 200}}) do
    Jason.decode(body)

  end

  def formatar_resposta({:ok, json}) do

    [
      json["logradouro"],
      json["complemento"],
      json["bairro"],
      json["localidade"],
      json["uf"],
      json["ddd"]
    ]

    |> Enum.filter(& String.length(&1) > 0 )
    |> Enum.join(", ")


  end
end

defmodule Pessoa do
  import Cep

  defstruct nome: "", cpf: "", cep: ""

  def new(nome, cpf, cep) do
    %Pessoa{nome: nome, cpf: cpf, cep: cep}
  end


  #def validate_cpf do
    #import CPF
 # end

  def info(pessoa) do
    import CPF
    data = [
      "Nome: #{pessoa.nome}, ",
      "\nCPF: #{pessoa.cpf}, ",
      "\nCPF válido? #{CPF.valid?(pessoa.cpf)}, ",
      "\nCep: #{pessoa.cep}, ",
      "\nendereço completo: #{run(pessoa.cep)} "
    ]

    path = File.cwd!<>"/DadosPessoa.txt"
    File.write(path, data, [:write, {:encoding, :latin1}])
  end


end


defmodule ProjetoPlp do
  import Pessoa
  import Cep
end

#p1 = Pessoa.new("Joao Paulo", "113.263.654-01", "57307420")
#Pessoa.info(p1)

