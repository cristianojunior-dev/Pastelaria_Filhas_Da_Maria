const bcrypt = require('bcrypt');

module.exports = {
    hash: async (senha) => {
        return await bcrypt.hash(senha, 10);
    },

    comparar: async (senha, hash) => {
        return await bcrypt.compare(senha, hash);
    }
};