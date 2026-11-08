const cds = require('@sap/cds');

const SUPPLIERS = 'company.procurement.Suppliers';

module.exports = cds.service.impl(function () {

    const { Suppliers } = this.entities;

    this.on('READ', Suppliers, async (req) => {
        return SELECT.from(SUPPLIERS);
    });

    this.on('CREATE', Suppliers, async (req) => {

        const tx = cds.tx(req);
        const data = { ...req.data };

        if (!data.supplierId) {
            const existing = await tx.run(
                SELECT.from(SUPPLIERS).columns('supplierId')
            );

            let maxNumber = 0;

            for (const supplier of existing) {
                const match = (supplier.supplierId || '').match(/^S(\d+)$/);

                if (match) {
                    maxNumber = Math.max(
                        maxNumber,
                        parseInt(match[1], 10)
                    );
                }
            }

            data.supplierId =
                'S' + String(maxNumber + 1).padStart(3, '0');
        }

        const now = new Date().toISOString();
        const user = req.user.id || 'integration';

        data.ID = cds.utils.uuid();
        data.createdAt = now;
        data.createdBy = user;
        data.modifiedAt = now;
        data.modifiedBy = user;

        await tx.run(
            INSERT.into(SUPPLIERS).entries(data)
        );

        return tx.run(
            SELECT.one.from(SUPPLIERS).where({ ID: data.ID })
        );
    });

});