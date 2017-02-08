require 'data_mapper'

class Crafter
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, :length => 255
  property :slack_id, String, :length => 255
end

__END__
teu Adsuara"              => "U03S7NV66"
3   "Georgina McFadyen"          => "U0BSE4FGT"
4   "Amelia Suchy"               => "U02RT4X4M"
5   "Jim Suchy"                  => "U029H4952"
6   "Daisy Mølving"              => "U2CF0PT5M"
7   "Enrique Comba Riepenhausen" => "U03FG4ML7"
8   "Will Curry"                 => "U1JP1LHE1"
9   "Fabien Townsend"            => "U28KRGNQ0"
10   "Gabriella Medas"            => "U2D5MNQ9F"
11   "Chris Jordan"               => "U03ACCZLA"
12   "Christoph"                  => "U02CY6PPZ"
13   "Priya Patil"                => "U096EJV4Y"
14   "Andrea Mazzarella"          => "U37N69161"
15   "Rabea Gleissner"            => "U0EK9543D"
16   "Mollie Stephenson"          => "U0XPHACR3"
17   "skim"                       => "U026MGKPV"
18   "That Silverlight Guy"       => "U02CY6R8H"
19   "Sarah Johnston"             => "U0BDT309L"
20   "Dipak Pankhania"            => "U2ZMTMBTK"
21 }
