const profundidad = 7

# PASO 1-2
function genera_texto(fichero)
    lista=[]
    for linea in eachline(fichero)
        palabras=split(linea)
        for palabra in palabras
            b_letras=true
            for letra in palabra
                if (!isletter(letra))
                    b_letras=false
                end
            end
            if b_letras 
                push!(lista,lowercase(palabra))
            end
        end
    end
    lista
end

# Prefijos y sufijos comunes de una palabra dada
# PASO 3
function dicc_palabra_frecuencias(libro,palabra_busqueda)
    palabra_busqueda_minusculas=lowercase(palabra_busqueda)
    lista_frecc_sufijos=Dict()
    lista_frecc_prefijos=Dict()
    idx=1
    for palabra in libro
        if libro[idx]==palabra_busqueda_minusculas
            sig1 = libro[idx+1]
            sig2 = libro[idx+2]
            ant1 = libro[idx-1]
            ant2 = libro[idx-2]
            # SUFIJOS
            if sig1 in keys(lista_frecc_sufijos)
                lista_frecc_sufijos[sig1]=lista_frecc_sufijos[sig1]+1
            else
                lista_frecc_sufijos[sig1]=1
            end
            if sig2 in keys(lista_frecc_sufijos)
                lista_frecc_sufijos[sig2]=lista_frecc_sufijos[sig2]+1
            else
                lista_frecc_sufijos[sig2]=1
            end
            # PREFIJOS
            if ant1 in keys(lista_frecc_prefijos)
                lista_frecc_prefijos[ant1]=lista_frecc_prefijos[ant1]+1
            else
                lista_frecc_prefijos[ant1]=1
            end
            if ant2 in keys(lista_frecc_prefijos)
               lista_frecc_prefijos[ant2]=lista_frecc_prefijos[ant2]+1
            else
                lista_frecc_prefijos[ant2]=1
            end
        end
        idx+=1
    end
    (lista_frecc_prefijos,lista_frecc_sufijos)
end

#PASO 4. Ordenar prefijos y sufijos por frecuencia.
function dicc_frecuencias_en_orden(pref,suf)
    ordenado_pre = sort(collect(pref), by = x -> x.second, rev = true)
    ordenado_suf = sort(collect(suf), by = x -> x.second, rev = true)
    (ordenado_pre,ordenado_suf)
end

#PASO 5.
function total_frec_prefijo_sufijo(pref,suf)
    (sum(values(pref))+1,sum(values(suf))+1)
end

function siguiente_semilla(prefijos,sufijos,total_prefijos,total_sufijos)
    pref_aleat = rand(1:total_prefijos)
    sufi_aleat = rand(1:total_sufijos)

    semilla_prefijo=""
    semilla_sufijo=""


    # Recorremos prefijos hasta que total_prefijos 
    sum_recorrida=0
    for (palabra,recorr) in prefijos
        if (pref_aleat<recorr)
            semilla_prefijo=palabra
            break
        else
            pref_aleat=pref_aleat-recorr
        end
    end

    sum_recorrida=0
    for (palabra,recorr) in sufijos
        if (sufi_aleat<recorr)
            semilla_sufijo=palabra
            break
        else
            sufi_aleat=sufi_aleat-recorr
        end
    end

    (semilla_prefijo,semilla_sufijo)
end

function lista_prefijos(prefijo_origen)
    l_prefijos = [prefijo_origen]
    for i in 1:profundidad
        (prefijos,sufijos)=dicc_palabra_frecuencias(lista_libro,prefijo_origen)  
        dicc_frecuencias_en_orden(prefijos,sufijos)   
        (t_total_pref,t_total_suf) = total_frec_prefijo_sufijo(prefijos,sufijos)
        (spref,ssuf)=siguiente_semilla(prefijos,sufijos,t_total_pref,t_total_suf)     
        pushfirst!(l_prefijos,spref)  
        prefijo_origen=spref         
    end
    l_prefijos
end

function lista_sufijos(sufijo_origen)
    l_sufijos = [sufijo_origen]
    for i in 1:profundidad
        (prefijos,sufijos)=dicc_palabra_frecuencias(lista_libro,sufijo_origen)  
        dicc_frecuencias_en_orden(prefijos,sufijos)   
        (t_total_pref,t_total_suf) = total_frec_prefijo_sufijo(prefijos,sufijos)
        (spref,ssuf)=siguiente_semilla(prefijos,sufijos,t_total_pref,t_total_suf)     
        push!(l_sufijos,ssuf)
        sufijo_origen=ssuf    
    end
    l_sufijos
end

palabra="Sancho"
lista_libro = genera_texto("DonQuijote.txt")
(prefijos,sufijos)=dicc_palabra_frecuencias(lista_libro,palabra)
println("Palabra : $palabra")
println("\tNro. prefijos : $(length(prefijos))")
println("\tNro. sufijos  : $(length(sufijos))")
dicc_frecuencias_en_orden(prefijos,sufijos)
(t_total_pref,t_total_suf) = total_frec_prefijo_sufijo(prefijos,sufijos)
println()
println("Total frec Prefijos : ",t_total_pref)
println("Total frec Sufijos  : ",t_total_suf)

# Pruebas de nuevas semillas
(spref,ssuf)=siguiente_semilla(prefijos,sufijos,t_total_pref,t_total_suf)

println("Frase creada : ")
frase=[lista_prefijos(spref) ; palabra; lista_sufijos(ssuf)]
for palabra in frase 
    print(palabra," ")
end
 
