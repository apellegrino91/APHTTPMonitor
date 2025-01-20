document.addEventListener("DOMContentLoaded", function () {
    const segmentedControls = document.querySelectorAll('.segmented-control-container');
    segmentedControls.forEach(control => {
        const items = control.querySelectorAll('.segmented-control-item');
        const tabContainers = control.parentElement.querySelectorAll('.tab-container');

        // Nascondi tutti i tab-container non selezionati all'avvio
        tabContainers.forEach(tab => {
            tab.style.display = 'none';
        });

        // Mostra solo il tab-container attivo all'avvio
        document.getElementById('req-1-container').style.display = 'block';
        document.getElementById('res-1-container').style.display = 'block';

        items.forEach(item => {
            item.addEventListener('click', function () {
                const itemsInContainer = control.querySelectorAll('.segmented-control-item');
                itemsInContainer.forEach(i => i.classList.remove('active'));
                this.classList.add('active');
                // Nascondi tutti i tab-container correlati
                tabContainers.forEach(tab => {
                    tab.style.display = 'none';
                });
                // Mostra il tab-container corrispondente
                const selectedTabContainer = document.getElementById(this.id + '-container');
                if (selectedTabContainer) {
                    selectedTabContainer.style.display = 'block';
                }
                // Aggiungi qui il codice per gestire l'azione del click
                const selectedItemId = this.id;
                console.log("ID dell'elemento attivo: " + selectedItemId + ", Testo: " + this.textContent);
            });
        });
    });
});
